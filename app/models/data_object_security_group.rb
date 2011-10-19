class DataObjectSecurityGroup < ActiveRecord::Base
  belongs_to :data_object
  belongs_to :security_group
   #updated_by
end
