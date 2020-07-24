class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :fullname
      t.date :date_of_birth
      t.string :gender
      t.string :id_number
      t.string :mobile
      t.string :email
      t.string :staff_id
      t.string :department
      t.string :barcode
      t.boolean :status, :default => true

      t.timestamps
    end
  end
end
