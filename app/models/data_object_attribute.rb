class DataObjectAttribute < ActiveRecord::Base
  #updated_by
  belongs_to :data_object
end
