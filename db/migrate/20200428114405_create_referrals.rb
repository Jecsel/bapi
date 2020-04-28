class CreateReferrals < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals do |t|
      t.string :code
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
