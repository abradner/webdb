class ImportMapping
  include Mongoid::Document
  include Tenacity
  belongs_to :file_type
  #belongs_to :raw_file
  t_belongs_to :data_object

  DELIMITERS = [["Comma", ","], ["Colon", ":"], ["Pipe", "|"], ["Semicolon", ";"], ["Space", "\\s"], ["Tab", "\\t"]]
  OVERRIDE = "Override"
  APPEND = "Append"
  DELETE = "Delete"
  RAW_FILES = ["contract", "customer_order_total", "GeoIPCountryWhois", "students", "transaction"] # temporary

  ACTIONS = [APPEND, OVERRIDE, DELETE]

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

  def display_name
    "#{self.name} (#{self.file_type.name})"
  end

end
