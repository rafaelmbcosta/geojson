class AddNameErrorsAndQueryToCoordinates < ActiveRecord::Migration[5.2]
  def change
    add_column :coordinates, :name, :string
    add_column :coordinates, :query, :string, null: false
    add_column :coordinates, :async_errors, :string
  end
end
