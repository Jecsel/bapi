class AutoApproveWorker
    include Sidekiq::Worker

    attr_accessor :ref_no, :tx_id, :signature

    def perform ref_no, tx_id
        @ref_no = ref_no
        @tx_id  = tx_id
        start_approval
    end
    

    private 
   
    def generate_payment_signature payment 
        code = "#{ENV["MERCHANT_KEY"]}#{ENV["MERCHANT_CODE"]}#{payment.payment_id}#{payment.ref_no}#{payment.amount.gsub('.', "")}#{payment.currency}1"
        return Digest::SHA256.hexdigest code 
    end
    def start_approval
        payments = Payment.where("ref_no = ?",ref_no)
        if payments.any?
            signature = generate_payment_signature payments.last
            make_payment_history payments.last,signature
            payments.last.update payment_status:1,payment_type:0
            BookingMailer.itinerary(payments.last.booking_id).deliver_later
            _slack = Slack.new
            _slack.channel("pah_covid")
            _slack.section("[#{ENV['APL_ENV']}] #{ref_no} - manual repush done")
            _slack.send
        else
            raise "no payment ref found for #{ref_no}"
        end
    end
    def make_payment_history payment ,signature
            hist            = payment.payment_histories.new
            hist.trans_id   = tx_id
            hist.auth_code  = "*****"
            hist.signature  = signature
            hist.ccname     = payment.username
            hist.ccno       = "*****"
            hist.s_bankname = "*****"
            hist.s_country  = "MY"
            hist.amount     = payment.amount
            hist.payment_reference = tx_id
            hist.save
    end
end