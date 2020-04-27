class PaymentWorker
    include Sidekiq::Worker
    def perform booking_reference
        p "###########"
        p "###########"
        p booking_reference
        p "###########"
        p "###########"
        p "###########"
    end
end