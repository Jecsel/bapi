class AddReceiptCountToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :receipt_count, :integer, :default => 1
  end
end
