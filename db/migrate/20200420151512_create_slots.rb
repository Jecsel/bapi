class CreateSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :slots do |t|
      t.belongs_to :schedule, index:true
      t.time :slot_time
      t.boolean :status
      t.integer :allocations
      t.timestamps
    end
  end
end
