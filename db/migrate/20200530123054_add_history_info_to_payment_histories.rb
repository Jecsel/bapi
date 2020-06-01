class AddHistoryInfoToPaymentHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_histories, :payment_mode_id, :integer
    add_column :payment_histories, :payment_reference, :string
    add_column :payment_histories, :payment_date, :datetime
  end
end
