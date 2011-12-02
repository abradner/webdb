class ImportMapping
  include Mongoid::Document
  include Tenacity
  belongs_to :file_type
  #belongs_to :raw_file
  belongs_to :data_object

  before_update :check_ids_mapped


  DELIMITERS = [["Comma", ","], ["Colon", ":"], ["Pipe", "|"], ["Semicolon", ";"], ["Space", "\\s"], ["Tab", "\\t"]]
  OVERWRITE = "Overwrite"
  APPEND = "Append"
  DELETE = "Delete"
  RAW_FILES = ["contract", "customer_order_total", "GeoIPCountryWhois", "students", "transaction"] # temporary

  ACTIONS = [APPEND, OVERWRITE, DELETE]

  # mappings are stored as "column_#{no}" => do_attr.id
  field :mappings, :type => Hash
  field :name, :type => String
  field :includes_header, :type => Boolean, :default => false
  field :delimiter, :type => String
  field :raw_file, :type => String # to be replaced
  field :unique_fields, :type => Array
  field :conflict_action, :type => String

  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:data_object_id, :file_type_id], :message => "has been taken in this data object"
  validates_presence_of :data_object_id, :file_type_id, :name
  validates_inclusion_of [:includes_header], :in => [true, false]

  def display_name
    "#{self.name} (#{self.file_type.name})"
  end

  def check_ids_mapped
    id_attrs = self.data_object.data_object_attributes.where(:is_id => true).collect(&:id)
    mapped_attrs = self.mappings.values
    puts mapped_attrs
    puts mapped_attrs.class
    puts id_attrs
    puts id_attrs.class
    unless id_attrs & mapped_attrs == id_attrs
      self.errors.add(:base, "All ID attributes must be mapped.")
    end
  end



end
