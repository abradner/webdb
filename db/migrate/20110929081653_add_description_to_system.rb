class AddDescriptionToSystem < ActiveRecord::Migration
  def change
    add_column :systems, :description, :string
  end
end
