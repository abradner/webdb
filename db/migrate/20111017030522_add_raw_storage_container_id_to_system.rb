class AddRawStorageContainerIdToSystem < ActiveRecord::Migration
  def change
    add_column :systems, :raw_storage_container_id, :string
  end
end
