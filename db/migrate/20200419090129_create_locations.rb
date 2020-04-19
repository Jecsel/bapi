class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :address
      t.string :longitude
      t.string :latitude
      t.timestamps
    end
  end
end
