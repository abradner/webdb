class System < ActiveRecord::Base
  include Tenacity
  belongs_to :colour_scheme
  t_has_many :data_objects, :dependent => :destroy
  has_many :security_groups, :dependent => :destroy
  t_has_many :storage_locations, :dependent => :destroy
  t_has_many :file_types


  has_many :memberships, :class_name => "SystemMember", :dependent => :destroy
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

  scope :active, where(:is_active => true).order(:name)
  scope :inactive, where(:is_active => false).order(:name)

  accepts_nested_attributes_for :memberships, :administrators

  validates :name, :presence => true, :if => Proc.new { |s| s.is_active?}
  validates :description, :presence => true, :if => Proc.new { |s| s.is_active?}
  validates :code, :presence => true, :if => Proc.new { |s| s.is_active?}
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 5000

  #updated_by

  before_validation do
    name.strip! if name
  end

  def files
    count = 0
    file_types.each do |ft|
      count += ft.raw_files.count
    end
    count
  end

  def deactivate!
    self.is_active = false
    save!(:validate => false)
  end

  def activate!
    self.is_active = true
    save!(:validate => false)
  end

  #def file(object_id)
  #
  #end

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
