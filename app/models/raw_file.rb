class RawFile
  include CarrierWave::Mongoid
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity


  t_belongs_to :user
  belongs_to :file_type
  embeds_one :file_metadata

  validates_presence_of :user_id
  mount_uploader :raw_file, RawStorageUploader

  before_save :configure_upload!

  field :historic_versions, :type => Array
  field :version_counter, :type => Integer
  field :imported, :type => Boolean


  private

  def build_store_dir
    File.join file_type.storage_location, id
  end

  def configure_upload!

    #Configure CarrierWave
    if file_type.use_grid?; CarrierWave::Uploader::Base.storage= :grid_fs
    elsif file_type.use_fs?; CarrierWave::Uploader::Base.storage= :file
    else; self.errors.add(:file_type, :invalid)
    end


    handle_versions!

    raw_file.set_store_dir build_store_dir



  end

  def handle_versions!

    return unless raw_file.changed?
    return unless file_type.versioning?
    self.version_counter+=1
    return if version_counter.eql? 1



    


    #TODO
  end

end
