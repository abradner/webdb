class FileType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity

  field :name, :type => String
  field :content, :type => String
  field :extensions, :type => Array
  field :versioning, :type => Boolean

  t_belongs_to :system
  belongs_to :storage_location
  has_many :import_mappings
  has_many :raw_files
  embeds_many :file_metadata_schemas


  #TODO security

  #updated_by

  before_save :clean_up_versioning

  def extension_list
    extensions.blank? ? "" : extensions.join(",")
  end

  def self.parse_extension_list(str)
    list = str.split(",")
    list.each do |ext|
      ext.slice!(0) if ext.start_with?(".")
    end
    list.compact!
    list
  end

  def use_grid?
    storage_location.storage_type.eql? AppConfig.file_locations.database
  end

  def use_fs?
    storage_location.storage_type.eql? AppConfig.file_locations.filesystem
  end

  def storage_path
    #TODO does not check that everything is well formed. This is a big issue!
    if storage_location.storage_type.eql? AppConfig.file_locations.filesystem
      File.join(AppConfig.raw_storage_root_path, storage_location.location, "system_" << system.id.to_s, "file_type_" << id.to_s)
    else
      File.join(storage_location.location, "system_" << system.id.to_s, "file_type_" << id.to_s)
    end
  end

  def data_objects
    dobjs = Array.new
    self.import_mappings.each do |im|
      dobj = im.data_object
      dobjs.insert(dobj) unless dobjs.include?(dobj)
    end
    dobjs
  end

  private

  def clean_up_versioning
    #TODO remove old versions of files from raw_files in this type
  end

end
