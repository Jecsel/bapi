class AddResourceOrderToServices < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :resource_order, :integer
  end
end
