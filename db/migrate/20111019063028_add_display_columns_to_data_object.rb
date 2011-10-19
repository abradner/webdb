class AddDisplayColumnsToDataObject < ActiveRecord::Migration
  def change
    add_column :data_objects, :display_columns, :integer
  end
end
