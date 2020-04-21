class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :fullname,
      t.string :id_number,
      t.int :gender_id
      t.date :date_of_birth
      t.string :contact_number
      t.string :email_address
      t.boolean :q1      
      t.boolean :q2
      t.timestamps
    end
  end
end