class CreateColourSchemes < ActiveRecord::Migration
  def change
    create_table :colour_schemes do |t|
      t.string :name

      #properties of the scheme, hex colours stored as "RRGGBB"
      #TODO fix spec
      t.string :banner, :limit => 6
      t.string :background, :limit => 6
      t.string :body, :limit => 6
      t.string :h1, :limit => 6
      t.string :h2, :limit => 6
      t.string :h3, :limit => 6
      t.string :a, :limit => 6
      t.string :a_visited, :limit => 6
      t.string :a_active, :limit => 6
      t.string :a_hover, :limit => 6

      t.timestamps
    end
  end
end
