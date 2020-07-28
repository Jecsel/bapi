class CreateInChargePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :in_charge_people do |t|
      t.string :name

      t.timestamps
    end
  end
end
