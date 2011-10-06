class AddSystemIdToSecurityGroups < ActiveRecord::Migration
  def change
    add_column :security_groups, :system_id, :integer
  end
end
