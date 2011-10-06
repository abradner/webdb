class AddShortDescriptionToDataObjects < ActiveRecord::Migration
  def change
    add_column :data_objects, :short_description, :string, :limit => 512
  end
end
