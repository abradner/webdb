class CreateDataObjects < ActiveRecord::Migration
  def change
    create_table :data_objects do |t|
      t.string :name

      t.timestamps
    end
  end
end
