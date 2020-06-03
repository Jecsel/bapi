class CreateSettingHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :setting_histories do |t|
      t.belongs_to :setting, index:true
      t.belongs_to :user, index:true
      t.string :setting_type
      t.string :old_value
      t.string :new_value
      t.timestamps
    end
  end
end
