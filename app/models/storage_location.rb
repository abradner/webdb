class StorageLocation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity
  t_belongs_to :system
  has_many :file_types, :dependent => :destroy

  field :name, :type => String
  field :storage_type, :type => String
  field :location, :type => String

  validates :name, :presence => true
  validates :system_id, :presence => true
#  validates :location, :presence => true, :unless => {:storage_type => :}
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates_length_of :name, :maximum => 255

  before_validation do
    name.strip! if name
  end

  def augmented_location
    if self.storage_type.eql? AppConfig.file_locations[:filesystem]
      File.join AppConfig.raw_storage_root_path, location
    else
      location
    end
  end

end
