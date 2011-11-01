class FileType < ActiveRecord::Base
  include Tenacity
  belongs_to :system
  belongs_to :storage
  belongs_to :file_content_type
  #TODO security
  has_and_belongs_to_many :data_objects

  t_has_many :raw_storage_containers
  #updated_by


  def self.use_grid_fs?
    return true if self.storage.storage_type.eql? AppConfig.file_locations.database
    false
  end

  def self.storage_location
    #TODO does not check that everything is well formed. This is a big issue!
    File.join(AppConfig.raw_storage_root_path, self.storage.location, self.system.name, self.name)
  end

end
