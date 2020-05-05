class AddStatusToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :status, :bool, :default => true
  end
end
