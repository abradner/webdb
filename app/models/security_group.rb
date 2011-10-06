class SecurityGroup < ActiveRecord::Base
  belongs_to :system
  has_many :data_objects, :through => :data_object_security_groups
end
