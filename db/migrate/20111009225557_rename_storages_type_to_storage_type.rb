class RenameStoragesTypeToStorageType < ActiveRecord::Migration
  def change
    rename_column :storages, :type, :storage_type
  end
end
