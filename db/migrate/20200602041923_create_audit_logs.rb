class CreateAuditLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_logs do |t|
      t.string :model
      t.string :field_name
      t.integer :field_id
      t.string :old_value
      t.string :new_value
      t.integer :action
      t.string :modified_by

      t.timestamps
    end
  end
end
