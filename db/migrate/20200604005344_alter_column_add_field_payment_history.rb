class AlterColumnAddFieldPaymentHistory < ActiveRecord::Migration[6.0]
  def change
    add_reference :payment_histories, :payment_mode, index:true
  end
end
