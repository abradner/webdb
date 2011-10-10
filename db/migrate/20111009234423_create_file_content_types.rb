class CreateFileContentTypes < ActiveRecord::Migration
  def change
    create_table :file_content_types do |t|
      t.string :name
      t.string :mime_type

      t.timestamps
    end
  end
end
