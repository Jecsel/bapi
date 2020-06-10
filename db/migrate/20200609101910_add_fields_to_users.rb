class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string
    add_column :users, :is_active, :boolean, :default => true
    add_column :users, :first_login, :boolean, :default => true
  end
end
