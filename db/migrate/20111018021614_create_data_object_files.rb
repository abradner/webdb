class CreateDataObjectFiles < ActiveRecord::Migration
  def change
    create_table :data_object_files do |t|
      t.integer :data_object_id
      t.string :raw_storage_container_id

      t.timestamps
    end
  end
end
