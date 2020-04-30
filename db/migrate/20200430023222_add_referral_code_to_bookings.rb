class AddReferralCodeToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :referral_code, :string
  end
end
