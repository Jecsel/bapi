class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :user_token
      t.boolean :status
      t.timestamps
    end
  end
end
