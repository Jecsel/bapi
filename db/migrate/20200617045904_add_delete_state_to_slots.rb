class AddDeleteStateToSlots < ActiveRecord::Migration[6.0]
  def change
    add_column :slots, :is_deleted, :boolean, default:false
  end
end
