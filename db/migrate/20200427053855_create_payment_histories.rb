class CreatePaymentHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_histories do |t|
      t.belongs_to :payment, index:true
      t.string :trans_id    #TransId
      t.string :auth_code   #AuthCode
      t.string :signature   #Signature
      t.string :ccname      #CCName
      t.string :ccno        #CCNo
      t.string :s_bankname  #S_bankname
      t.string :s_country   #S_country
      t.string :amount
      t.timestamps
    end
  end
end
