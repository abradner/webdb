class CreateRawStorages < ActiveRecord::Migration
  def change
    create_table :raw_storages do |t|
      t.string :name
      t.string :type
      t.string :location

      t.timestamps
    end
  end
end
