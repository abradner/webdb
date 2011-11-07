class ImportMapping
  include Mongoid::Document
  include Tenacity
  #field :data_object_id, :type => Integer
#  field :file_type_id, :type => Integer
  t_belongs_to :file_type
  t_belongs_to :data_object
end
