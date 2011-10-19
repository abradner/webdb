class DataObject < ActiveRecord::Base
  #has_and_belongs_to_many :file_data_types
  #has_many :custom_fields  # the builder could be smart - custom fields can be suggested from existing templates
  #has_one  :file_system, :dependent => :destroy
  belongs_to :system
  has_many :security_groups, :through => :data_object_security_groups
  has_many :data_object_security_groups, :dependent => :destroy
  has_and_belongs_to_many :file_types

  has_many :data_object_relationships, :dependent => :destroy
  has_many :relatives, :through => :data_object_relationships

  has_many :inverse_data_object_relationships, :class_name => "DataObjectRelationship", :foreign_key => "relative_id"
  has_many :inverse_relatives, :through => :inverse_data_object_relationships, :source => :data_object

  has_many :data_object_attributes

  accepts_nested_attributes_for :data_object_attributes, :allow_destroy => true, :reject_if => :all_blank

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates :short_description, :presence => true
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 5000
  validates_length_of :short_description, :maximum => 512
  validates :display_columns, :numericality => {:greater_than => 0, :less_than_or_equal_to => 3, :only_integer => true}

  #updated_by

  before_validation do
    name.strip! if name
  end

  def unrelated
    ids = System.find(self.system_id).data_object_ids - self.relative_ids - Array(self.id)
    DataObject.find(ids)
  end

end
