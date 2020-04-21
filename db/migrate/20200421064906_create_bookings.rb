class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.belongs_to :patient, index:true
      t.belongs_to :location, index:true
      t.belongs_to :slot, index:true
      t.belongs_to :schedule, index:true
      t.belongs_to :clinic
      t.string :reference_code
      t.string :amount
      t.timestamps
    end
  end
end
