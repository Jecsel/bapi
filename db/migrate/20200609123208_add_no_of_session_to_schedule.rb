class AddNoOfSessionToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :no_of_session, :integer
  end
end
