class CreateDataObjectsFileTypes < ActiveRecord::Migration
  def change
    create_table :data_objects_file_types, :id => false do |t|
      t.integer :data_object_id, :null => false
      t.integer :file_type_id, :null => false

      t.timestamps
    end

    add_index :data_objects_file_types, ["data_object_id"], :name => "data_objects_file_types_data_object_id_index"
  end
end
