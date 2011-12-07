class DataObjectRow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object
  belongs_to :data_object_attribute

end

