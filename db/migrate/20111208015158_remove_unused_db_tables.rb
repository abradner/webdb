class RemoveUnusedDbTables < ActiveRecord::Migration
  def up
    drop_table :data_objects
    drop_table :data_object_attributes
    drop_table :data_object_relationships
    drop_table :data_object_security_groups
    drop_table :storage_locations
    drop_table :updated_actions
    drop_table :file_types
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted tables"
  end
end
