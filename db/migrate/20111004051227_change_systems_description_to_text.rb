class ChangeSystemsDescriptionToText < ActiveRecord::Migration
  def change
    change_column :systems, :description, :text
  end
end
