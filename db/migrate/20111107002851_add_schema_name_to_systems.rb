class AddSchemaNameToSystems < ActiveRecord::Migration
  def change
    add_column :systems, :schema_name, :string
  end
end
