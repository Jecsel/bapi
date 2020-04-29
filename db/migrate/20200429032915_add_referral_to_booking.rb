class AddReferralToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :referral_id, :integer
  end
end
