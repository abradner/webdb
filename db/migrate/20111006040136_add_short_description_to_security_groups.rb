class AddShortDescriptionToSecurityGroups < ActiveRecord::Migration
  def change
    add_column :security_groups, :short_description, :string, :limit => 512
  end
end
