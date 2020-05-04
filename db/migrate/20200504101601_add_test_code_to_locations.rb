class AddTestCodeToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :code, :string
  end
end
