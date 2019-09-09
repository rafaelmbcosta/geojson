class CreateFeatureCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_collections do |t|
      t.json :areas

      t.timestamps
    end
  end
end
