class UserSecurityGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :security_group
end
