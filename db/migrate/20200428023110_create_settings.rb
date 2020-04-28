class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.decimal :covid_price, precision: 10, scale: 2
      t.integer :booking_date_range
      t.timestamps
    end
  end
end
