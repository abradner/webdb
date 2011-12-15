class FixSystemsTableIssues < ActiveRecord::Migration
  def up
    sys = System.find_all_by_is_active(nil)
    sys.each do |s|
      s.update_attribute(:is_active, false)
    end
    change_column :systems, :is_active, :boolean, :default => false, :null => false
    remove_column :systems, :raw_storage_container_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted column"
  end
end
