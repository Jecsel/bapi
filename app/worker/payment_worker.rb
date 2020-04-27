class PaymentWorker
    include Sidekiq::Worker

    attr_accessor :payment, :histories, :payment_id

    def perform pay_id, history_id, payment_id
        @payment_id = payment_id
        @payment     = Payment.find pay_id
        @histories   = payment.payment_histories.where("id = ?",history_id)
        
        validate_payment
        start_payment_approval
    end
    

    private 
    def start_payment_approval
        if histories.last.signature == generate_system_signature
            payment.update status:1
        else
            raise "invalid payment signature"
        end
    end
    def validate_payment
        raise "Payment detail not found" if payment.nil?
        raise "Payment history not found" if histories.empty?
        raise "Payment signature is required" if histories.last.signature.blank?
    end

    def generate_system_signature
        __code = "#{ENV["MERCHANT_KEY"]}#{ENV["MERCHANT_CODE"]},#{payment_id}#{payment.ref_no}#{payment.amount.gsub('.', "")}#{payment.currency}1"
        p "------"
        p __code
        p "------"
        return Digest::SHA256.hexdigest __code
    end
end