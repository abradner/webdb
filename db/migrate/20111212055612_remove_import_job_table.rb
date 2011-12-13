class RemoveImportJobTable < ActiveRecord::Migration
  def up
    drop_table :import_jobs
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted tables"
  end
end
