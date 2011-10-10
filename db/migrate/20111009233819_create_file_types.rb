class CreateFileTypes < ActiveRecord::Migration
  def change
    create_table :file_types do |t|
      t.string :name
      t.integer :storage_id
      t.integer :system_id
      t.integer :file_content_type_id

      t.timestamps
    end
  end
end
