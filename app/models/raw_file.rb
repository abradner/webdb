class RawFile
  include CarrierWave::Mongoid
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity


  t_belongs_to :user
  belongs_to :file_type
  embeds_one :file_metadata

  validates_presence_of :user_id
  validates :raw_file, :presence => true

  validate :valid_file_extension

  mount_uploader :raw_file, RawStorageUploader


  before_validation :configure_upload!#, :verify_upload!

  field :name, :type => String
  field :size, :type => Integer
  field :historic_versions, :type => Array
  field :version_counter, :type => Integer
  field :imported, :type => Boolean


  private

  def valid_file_extension
    return if file_type.extensions.blank?
    debugger
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

    #Configure CarrierWave
    if file_type.use_grid?; CarrierWave::Uploader::Base.storage= :grid_fs
    elsif file_type.use_fs?; CarrierWave::Uploader::Base.storage= :file
    else; self.errors.add(:file_type, :invalid)
    end


    handle_versions!

    raw_file.set_store_dir build_store_dir

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
