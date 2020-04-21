class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.belongs_to :patient, index:true
      t.belongs_to :booking, index:true
      t.string :merchant_code
      t.string :payment_id
      t.string :ref_no
      t.string :amount
      t.string :currency
      t.text :prod_desc
      t.string :username
      t.string :user_email
      t.string :user_contact
      t.string :remark
      t.string :lang
      t.string :signature_type
      t.string :signature
      t.integer :payment_status
      t.integer :payment_type
      t.timestamps
    end
  end
end
