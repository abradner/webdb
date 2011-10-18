class System < ActiveRecord::Base
  include Tenacity
#  has_many :storage_types
  belongs_to :colour_scheme
  belongs_to :storage
#  has_many :file_data_types, :dependent => :destroy
  has_many :data_objects, :dependent => :destroy
  has_many :security_groups, :dependent => :destroy
  has_many :file_types, :dependent => :destroy
  has_many :storages, :through => :file_types #TODO this is going to be slow

  has_many :file_containers, :class_name => "SystemFile"

  t_has_many :raw_storage_containers 

  #See comment in User model on has_many :systems
  #belongs_to :user

  has_many :memberships, :class_name => "SystemMember"
  has_many :collaborations, :class_name => "SystemMember", :conditions => {:administrator => false}
  has_many :administrations, :class_name => "SystemMember", :conditions => {:administrator => true}

  has_many :members,
           :through => :memberships,
           :class_name => 'User',
           :source => :user

  has_many :collaborators,
           :through => :collaborations,
           :class_name => 'User',
           :source => :user

  has_many :administrators,
           :through => :administrations,
           :class_name => 'User',
           :source => :user


  accepts_nested_attributes_for :memberships, :administrators

  validates :name, :presence => true
  validates :description, :presence => true
  validates :code, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 5000

  before_validation do
    name.strip! if name
  end

  def files
    raw_storage_container_id
  end

  def file(object_id)

  end
 # scope :partial_systems, joins(:users).


  #Finds any systems that are incomplete - ie currently have no administrators (which is the last step)
  #def partial_systems
  #  #TODO
  #  nil
  #end

  private
  def get_members

  end

end
