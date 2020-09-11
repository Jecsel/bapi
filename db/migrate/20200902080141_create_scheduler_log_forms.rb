class CreateSchedulerLogForms < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduler_log_forms do |t|
      t.string :date_from
      t.string :date_to 
      t.text :days
      t.integer :allocation_per_slot
      t.integer :minute_interval
      t.integer :no_of_session
      t.text :first_session
      t.text :second_session
      t.belongs_to :location, index:true
      t.timestamps
    end
  end
end
