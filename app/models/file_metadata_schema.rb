class FileMetadataSchema
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label, :type => String
  field :field_type, :type => String
  field :required, :type => Boolean
  field :select_options, :type => Array
  field :field_parameters

  embedded_in :file_type
  

  #def has_array_of_values?
  #  return type == "Multi"
  #end
  #
  #def has_options?
  #  return type == "Multi" || type == "Select"
  #end
  #
end
