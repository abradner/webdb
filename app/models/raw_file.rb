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
  after_initialize :configure_upload


  private

  def build_store_dir
    "#{self.class.to_s.underscore}/"
  end

  def configure_upload
    if file_type.use_grid?
      CarrierWave::Uploader::Base.storage= :grid_fs
      raw_file.set_store_dir build_store_dir
    end

    if file_type.use_fs?
      CarrierWave::Uploader::Base.storage= :file
      raw_file.set_store_dir build_store_dir
    end
  end

end
