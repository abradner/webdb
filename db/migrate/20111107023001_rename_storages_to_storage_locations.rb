class RenameStoragesToStorageLocations < ActiveRecord::Migration
  def change
    rename_table :storages, :storage_locations
    add_column :storage_locations, :system_id, :integer

    rename_column :file_types, :storage_id, :storage_location_id

  end
end
