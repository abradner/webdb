class CreateDataObjectAttributes < ActiveRecord::Migration
  def change
    create_table :data_object_attributes do |t|
      t.integer :data_object_id
      t.string :name, :limit => 45
      t.string :label, :limit => 255
      t.string :type, :limit => 45
      t.integer :length
      t.boolean :required, :default => false
      t.boolean :is_id, :default => false
      t.boolean :editable, :default => true
      t.integer :column

      t.timestamps
    end
  end
end
