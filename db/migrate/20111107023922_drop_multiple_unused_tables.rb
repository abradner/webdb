class DropMultipleUnusedTables < ActiveRecord::Migration
  def up
    drop_table :data_objects_file_types
    drop_table :data_object_files
    drop_table :file_content_types
    remove_column :file_types, :file_content_type_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted tables"
  end
end
