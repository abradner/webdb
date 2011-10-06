class SecurityGroup < ActiveRecord::Base
  belongs_to :system

  has_many :data_objects, :through => :data_object_security_groups
  has_many :data_object_security_groups, :dependent => :destroy

  has_many :users, :through => :user_security_groups
  has_many :user_security_groups, :dependent => :destroy



  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates :short_description, :presence => true
  validates_length_of :name, :maximum => 255
  validates_length_of :short_description, :maximum => 512


  before_validation do
    name.strip! if name
  end

end
