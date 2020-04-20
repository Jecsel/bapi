class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.date :schedule_date
      t.integer :allocation_per_slot
      t.integer :minute_interval
      t.time :morning_start_time
      t.time :morning_end_time
      t.time :afternoon_start_time
      t.time :afternoon_end_time
      t.timestamps
    end
  end
end
