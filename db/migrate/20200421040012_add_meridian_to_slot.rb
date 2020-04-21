class AddMeridianToSlot < ActiveRecord::Migration[6.0]
  def change
    add_column :slots, :meridian, :string
  end
end
