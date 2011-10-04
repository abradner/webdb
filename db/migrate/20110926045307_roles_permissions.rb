class RolesPermissions < ActiveRecord::Migration
  def change
    create_table :roles_permissions, :id => false do |t|
      t.references :role, :permission
    end
  end
end
