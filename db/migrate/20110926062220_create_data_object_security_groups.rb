class CreateDataObjectSecurityGroups < ActiveRecord::Migration
  def change
    create_table :data_object_security_groups, :id => false do |t|
      t.integer :data_object_id
      t.integer :security_group_id
      t.boolean :read
      t.boolean :write
      t.boolean :admin

      t.timestamps
    end

    add_index :data_object_security_groups, ["data_object_id"], :name => "data_object_security_groups_data_object_id_index"
  end
end
