class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity

  t_belongs_to :system

  #t_has_many :security_groups, :through => :data_object_security_groups
  #t_has_many :data_object_security_groups, :dependent => :destroy

  #has_many :data_object_relationships, :dependent => :destroy
  #has_many :relatives, :through => :data_object_relationships
  #
  #has_many :inverse_data_object_relationships, :class_name => "DataObjectRelationship", :foreign_key => "relative_id"
  #has_many :inverse_relatives, :through => :inverse_data_object_relationships, :source => :data_object

  has_many :data_object_attributes, :dependent => :destroy
  has_many :data_object_rows, :dependent => :destroy
  has_many :import_mappings, :dependent => :destroy
  has_many :import_jobs, :dependent => :destroy

  field :name,              :type => String
  field :description,       :type => String
  field :short_description, :type => String
  field :display_columns,   :type => Integer
  field :is_active,         :type => Boolean

  scope :inactive, where(:is_active => false)
  scope :active, where(:is_active => true)

  accepts_nested_attributes_for :data_object_attributes, :allow_destroy => true, :reject_if => :all_blank

  validates :name, :presence => true #, :if => Proc.new { |d| d.is_active?}
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates :short_description, :presence => true #, :if => Proc.new { |d| d.is_active?}
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 5000
  validates_length_of :short_description, :maximum => 255
  validates :display_columns, :numericality => {:greater_than => 0, :less_than_or_equal_to => 3, :only_integer => true}
  validates_presence_of :system_id

  #updated_by


  before_validation do
    name.strip! if name
  end


  def deactivate!
    self.is_active = false
    save!(:validate => false)
  end

  def activate!
    self.is_active = true
    save!(:validate => false)
  end

  #def unrelated
  #  ids = System.find(self.system_id).data_object_ids - self.relative_ids - Array(self.id)
  #  DataObject.find(ids)
  #end

end
