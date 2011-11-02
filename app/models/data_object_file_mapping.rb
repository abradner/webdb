class DataObjectFileMapping
  include Mongoid::Document
  field :data_object_id, :type => Integer
  field :file_type_id, :type => Integer
end
