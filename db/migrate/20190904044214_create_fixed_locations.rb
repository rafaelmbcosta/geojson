class CreateFixedLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :fixed_locations do |t|

      t.timestamps
    end
  end
end
