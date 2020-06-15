class AddStatusToSchdules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :status, :boolean, default:true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
