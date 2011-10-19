class RenameDataObjectAttributesTypeToAttributeType < ActiveRecord::Migration
  def change
    rename_column :data_object_attributes, :type, :attribute_type
  end
end
