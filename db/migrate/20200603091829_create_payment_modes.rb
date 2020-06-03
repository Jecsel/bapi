class CreatePaymentModes < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_modes do |t|
      t.string :name
      t.timestamps
    end
  end
end
