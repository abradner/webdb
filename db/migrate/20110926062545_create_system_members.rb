class CreateSystemMembers < ActiveRecord::Migration
  def change
    create_table :system_members, :id => false do |t|
      t.integer :system_id, :null => false
      t.integer :data_object_id, :null => false
      t.boolean :administrator, :default => false

      t.timestamps
    end

    add_index :system_members, ["system_id"], :name => "system_members_system_id_index"
  end
end
