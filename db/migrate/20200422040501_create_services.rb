class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.string :name
      t.boolean :status
      t.string :resource_path
      t.string :resource_icon

      t.timestamps
    end
  end
end
