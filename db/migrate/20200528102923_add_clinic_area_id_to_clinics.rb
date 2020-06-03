class AddClinicAreaIdToClinics < ActiveRecord::Migration[6.0]
  def change
    add_reference :clinics, :clinic_area, index:true
  end
end
