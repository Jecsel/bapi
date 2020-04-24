class CreateRolePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :role_policies do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.references :service_policy, null: false, foreign_key: true
      t.boolean :status

      t.timestamps
    end
  end
end
