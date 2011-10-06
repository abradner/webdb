class AddDescriptionToDataObject < ActiveRecord::Migration
  def change
    add_column :data_objects, :description, :text
  end
end
