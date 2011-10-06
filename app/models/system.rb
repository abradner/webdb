class System < ActiveRecord::Base
#  has_many :storage_types
  belongs_to :colour_scheme
#  has_many :file_data_types, :dependent => :destroy
  has_many :data_objects, :dependent => :destroy

  has_many :security_groups

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


 # scope :partial_systems, joins(:users).


  #Finds any systems that are incomplete - ie currently have no administrators (which is the last step)
  #def partial_systems
  #  #TODO
  #  nil
  #end

  def first_name
    
  end
end
