#class FileType < ActiveRecord::Base #TODO convert to mongo
class FileType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity
  #belongs_to :system
  #belongs_to :storage_location
  #t_has_many :import_mappings
  #t_has_many :raw_files

  field :name, :type => String
  field :content, :type => String
  field :extensions, :type => String #change to array

  t_belongs_to :system
  t_belongs_to :storage_location
  has_many :import_mappings
  has_many :raw_files
  embeds_many :file_metadata_schemas

  #Metadata Schema

  #TODO security

  #updated_by


  def self.use_grid_fs?
    return true if self.storage.storage_type.eql? AppConfig.file_locations.database
    false
  end

  def self.storage_location
    #TODO does not check that everything is well formed. This is a big issue!
    File.join(AppConfig.raw_storage_root_path, self.storage.location, self.system.name, self.name)
  end

  def data_objects
    dobjs = Array.new
    self.import_mappings.each do |im|
      dobj = im.data_object
      dobjs.insert(dobj) unless dobjs.include?(dobj)
    end
    dobjs
  end

end
