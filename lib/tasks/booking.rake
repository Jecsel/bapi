namespace :booking do
    desc "TODO"
    task payment_type: :environment do
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
    ActiveRecord::Base.connection.execute("TRUNCATE payment_modes")
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")
      _payment_modes = [
          {
              name:"Online transfer",
              payment_type: "manual"
          },
          {
              name:"ATM transfer/banking",
              payment_type: "manual"
          },
          {
              name:"iPay88",
              payment_type: "auto"
          }
     
      ]
      PaymentMode.create _payment_modes
      p "Created payment types"
    end
  
  end
  