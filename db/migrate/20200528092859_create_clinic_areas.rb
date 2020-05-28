class CreateClinicAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :clinic_areas do |t|
      t.string :name
      t.boolean :status, default:true
      t.timestamps
    end
  end
end
