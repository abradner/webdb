class AddSystemIdToDataObjects < ActiveRecord::Migration
  def change
    add_column :data_objects, :system_id, :integer
  end
end
