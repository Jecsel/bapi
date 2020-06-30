class AddPaymentTypeToPaymentMode < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_modes, :payment_type, :string
  end
end
