class CreateCoordinates < ActiveRecord::Migration[5.2]
  def change
    create_table :coordinates do |t|
      t.decimal :x, precision: 18, scale: 16 
      t.decimal :y, precision: 18, scale: 16
      t.boolean :inside_polygon, default: nil
      t.references :feature_collection, foreign_key: true
      t.timestamps
    end
  end
end
