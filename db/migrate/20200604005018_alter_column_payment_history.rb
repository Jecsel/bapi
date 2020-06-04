class AlterColumnPaymentHistory < ActiveRecord::Migration[6.0]
  def change
    remove_column :payment_histories, :payment_mode_id
  end
end
