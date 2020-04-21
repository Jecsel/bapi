class CreateClinics < ActiveRecord::Migration[6.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :code, :unique =>  true
      t.timestamps
    end
    add_index :clinics, [:code], unique: true
  end
end
