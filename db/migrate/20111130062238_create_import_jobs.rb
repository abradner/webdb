class CreateImportJobs < ActiveRecord::Migration
  def up

    create_table :import_jobs, :force => true do |table|
      table.integer :import_mapping_id
      table.integer :data_object_id
      table.integer :raw_file_id
      table.integer :created_by_user
      table.string :status

      table.timestamps

    end
  end

  def down
  end
end
