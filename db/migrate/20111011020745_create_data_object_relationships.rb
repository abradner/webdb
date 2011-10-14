class CreateDataObjectRelationships < ActiveRecord::Migration
  def change
    create_table :data_object_relationships do |t|
      t.integer :data_object_id
      t.integer :relative_id

      t.timestamps
    end
  end
end
