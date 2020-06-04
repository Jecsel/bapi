class AddApprovedByToPaymentHistory < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_histories, :approved_by, :string
  end
end
