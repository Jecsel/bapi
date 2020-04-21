class CreateLocationClinics < ActiveRecord::Migration[6.0]
  def change
    create_table :location_clinics do |t|
      t.references :location
      t.references :clinic

      t.timestamps
    end
  end
end
