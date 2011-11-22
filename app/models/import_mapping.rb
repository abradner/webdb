class ImportMapping
  include Mongoid::Document
  include Tenacity
  belongs_to :file_type
  #belongs_to :raw_file
  t_belongs_to :data_object

  DELIMITERS = [["Comma", ","], ["Colon", ":"], ["Pipe", "|"], ["Semicolon", ";"], ["Space", "\\s"], ["Tab", "\\t"]]
  #DELIMITERS = ["Comma", "Tab", "Semicolon", "Space", "Pipe"]

  # mappings are stored as "column_#{no}" => do_attr.id
  field :mappings, :type => Hash
  field :name, :type => String
  field :includes_header, :type => Boolean, :default => false
  field :delimiter, :type => String
  field :raw_file, :type => String

  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:data_object_id, :file_type_id], :message => "has been taken in this data object"
  validates_presence_of :data_object_id, :file_type_id, :name

end
