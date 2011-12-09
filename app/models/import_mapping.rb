class ImportMapping
  include Mongoid::Document
  include Tenacity
  belongs_to :file_type
  belongs_to :raw_file
  belongs_to :data_object

  validate :all_unique_fields_mapped
  validate :all_required_fields_mapped
  validate :only_append_if_no_ids


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
  field :unique_fields, :type => Array
  field :conflict_action, :type => String
  field :num_of_columns, :type => Integer
  field :header_row, :type => Array

  validates_uniqueness_of :name, :case_sensitive => false, :scope => [:data_object_id, :file_type_id], :message => "has been taken in this data object"
  validates_presence_of :data_object_id, :file_type_id, :name
  validates_inclusion_of [:includes_header], :in => [true, false]

  def display_name
    "#{self.name} (#{self.file_type.name})"
  end

  def all_unique_fields_mapped
    if self.mappings.present?
      mapped_attrs = self.mappings.values
      mapped_unique_attrs = unique_fields & mapped_attrs
      unless mapped_unique_attrs == unique_fields
        self.errors.add(:base, "All ID and additional unique attributes must be mapped.")
      end

    end
  end

  def all_required_fields_mapped
    if self.mappings.present?
      mapped_attrs = self.mappings.values
      required_attrs = data_object.data_object_attributes.required.collect { |doa| doa.id.to_s }
      mapped_required_attrs = required_attrs & mapped_attrs
      if self.conflict_action == APPEND and mapped_required_attrs != required_attrs
        self.errors.add(:base, "All required attributes must be mapped for an 'Append' mapping.")
      end

    end
  end

  def only_append_if_no_ids

  end


end
