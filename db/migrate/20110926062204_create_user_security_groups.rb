class CreateUserSecurityGroups < ActiveRecord::Migration
  def change
    create_table :user_security_groups, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :security_group_id, :null => false

      t.timestamps
    end

    add_index :user_security_groups, ["user_id"], :name => "user_security_groups_user_id_index"
  end
end
