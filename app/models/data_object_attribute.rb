class DataObjectAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,            :type => String
  field :label,           :type => String
  field :attribute_type,  :type => String
  field :options,         :type => String
  field :length,          :type => Integer
  field :column,          :type => Integer
  field :sort_order,      :type => Integer
  field :required,        :type => Boolean,       :default => false
  field :is_id,           :type => Boolean,       :default => false
  field :editable,        :type => Boolean,       :default => true
  field :visible,         :type => Boolean,       :default => false

  #updated_by
  belongs_to :data_object

  #validates :name, :presence => true #, :if => Proc.new { |d| d.is_active?}
  validates_presence_of [:name, :label, :attribute_type, :sort_order]
  validates_inclusion_of [:required, :is_id, :editable, :visible], :in => [true, false]
  validates_inclusion_of :attribute_type, :in => AppConfig.attribute_types.keys

  validates_length_of :name, :maximum => 45
  validates_length_of :label, :maximum => 255

  validates_uniqueness_of :name, :case_sensitive => false, :scope => :data_object_id, :message => "has been taken in this data object"
  validates_uniqueness_of :label, :case_sensitive => false, :scope => :data_object_id, :message => "has been taken in this data object"
  validates_uniqueness_of :sort_order, :scope => :data_object_id, :message => "Conflicting Sort Order. This shouldn't happen, raise a support ticket"

  validate :reserved_names
  validate :id_is_required

  scope :visible_fields, where(:visible => true)
  scope :hidden_fields, where(:visible => false)
  scope :required, where(:required => true)
  scope :is_id, where(:is_id => true)

  def reserved_names
    if AppConfig['reserved_attribute_names'].include?(self.name)
      self.errors.add(:base, "Internal name is reserved and cannot be used.")
    end
  end

  def id_is_required
    if self.is_id
      self.errors.add(:base, "IDs should be marked as required attributes") unless self.required
    end
  end
end

