class RenameRawStorageToStorage < ActiveRecord::Migration
  def change
    rename_table :raw_storages, :storages
  end
end
