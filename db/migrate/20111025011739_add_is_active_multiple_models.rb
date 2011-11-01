class AddIsActiveMultipleModels < ActiveRecord::Migration
  def change
    add_column :systems, :is_active, :boolean
    add_column :data_objects, :is_active, :boolean
  end
end
