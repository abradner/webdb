class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :name
      t.string :code, :limit => 12 #TODO fix spec
      t.integer :colour_scheme_id

      t.timestamps
    end
  end
end
