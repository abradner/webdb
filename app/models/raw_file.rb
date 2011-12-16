class RawFile
  include CarrierWave::Mongoid
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity


  t_belongs_to :user
  belongs_to :file_type
  #embeds_one :file_metadata

  validates_presence_of :raw_file, :file_type, :user_id

  validates_uniqueness_of :name, :case_sensitive => true, :scope => :file_type_id, :message => "file exists in this file type collection"


  validate :valid_file_extension

  mount_uploader :raw_file, RawStorageUploader


  before_validation :configure_upload! #, :verify_upload!

  field :imported,                :type => Boolean

  field :name,                    :type => String
  field :cached_path,             :type => String
  field :cached_storage_location, :type => String

  field :size,                    :type => Integer
  field :size_with_versions,      :type => Integer
  field :version_counter,         :type => Integer

  field :historic_versions,       :type => Array
  field :file_metadata,           :type => Hash



  def open_file
    file_path = File.join(self.cached_path, self.name)
    begin
      case self.cached_storage_location
        when AppConfig.file_locations.database
          return Mongo::GridFileSystem.new(Mongoid.database).open(file_path, 'r')
        when AppConfig.file_locations.filesystem
          return File.open(file_path, 'r')
      end
      nil
    rescue
      nil
    end

  end

  def version_words
    case self.version_counter
      when nil, 0
        return "Unversioned"
      when 1
        return "Initial"
      else
        return self.version_counter.to_s
    end
  end

  private

  def valid_file_extension
    return if file_type.extensions.blank?
    extension = File.extname(name)
    extension.slice!(0) if extension.start_with?(".")

    unless file_type.extensions.include?(extension)
      errors.add :raw_file, " is not an accepted type (Valid: #{file_type.extension_list})"
    end
  end

  def build_store_dir
    File.join file_type.storage_path, "file_" << id.to_s
  end

  def verify_upload!
    raw_file.set_extension_white_list file_type.extensions
  end

  def configure_upload!
    self.name = raw_file.filename
    self.size = raw_file.size
    self.cached_path = build_store_dir


    #Configure CarrierWave
    #TODO Tidy, DRY and refactor this block
    if file_type.use_grid?
      CarrierWave::Uploader::Base.storage= :grid_fs
      self.cached_storage_location = AppConfig.file_locations.database
    elsif file_type.use_fs?
      CarrierWave::Uploader::Base.storage= :file
      self.cached_storage_location = AppConfig.file_locations.filesystem
    else
      self.errors.add(:file_type, :invalid)
      return
    end


    handle_versions!

    raw_file.set_store_dir self.cached_path

    unless Rails.env.production?

      out = "================================\n" <<
          "Storing file #{name}, #{size } (Version #{version_counter || 0}) in\n" <<
          raw_file.store_dir << "via \n" <<
          raw_file.get_storage.to_s << "\n" <<
          "================================\n"
      Rails.logger.debug out
    end

  end

  def handle_versions!

    return unless changed?
    return unless file_type.versioning?
    self.version_counter+=1
    return if version_counter.eql? 1

    #TODO write the renaming and storing-of-old-version stuff
  end

end
