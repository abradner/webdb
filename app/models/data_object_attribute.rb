class DataObjectAttribute
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,            :type => String
  field :label,           :type => String
  field :attribute_type,  :type => String
  field :options,         :type => String
  field :length,          :type => Integer
  field :column,          :type => Integer
  field :required,        :type => Boolean,       :default => false
  field :is_id,           :type => Boolean,       :default => false
  field :editable,        :type => Boolean,       :default => true
  field :visible,         :type => Boolean,       :default => false

  #updated_by
  belongs_to :data_object

  validates :name, :presence => true #, :if => Proc.new { |d| d.is_active?}
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :data_object_id, :message => "has been taken in this data object"
  validates_length_of :name, :maximum => 45
  validates_length_of :label, :maximum => 255

  scope :visible_fields, where(:visible.eql? true) #TODO build visible field

end

