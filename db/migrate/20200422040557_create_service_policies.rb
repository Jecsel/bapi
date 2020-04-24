class CreateServicePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :service_policies do |t|
      t.references :service, null: false, foreign_key: true
      # t.references :role, null: false, foreign_key: true
      t.string :name
      t.boolean :status

      t.timestamps
    end
  end
end
