class CreateSecurityGroups < ActiveRecord::Migration
  def change
    create_table :security_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
