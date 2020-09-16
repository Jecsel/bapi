class GmailWorker
    include Sidekiq::Worker

    def perform
        gmail = Gmail.connect(ENV['PAYMENT_EMAIL_USERNAME'],ENV['PAYMENT_EMAIL_PASSWORD'])
        gmail.inbox.find(:unread).each do |email|
            if email.subject.include? "Payment Confirmation"
                ref_no = email.subject.to_s.split(" ").last[1...13]
                payments = Payment.where("ref_no = ?",ref_no)
                if payments.any?
                    if payments.last.payment_status == "confirmed"
                        _slack = Slack.new
                        _slack.channel("pah_covid")
                        _slack.section("[#{ENV['APL_ENV']}] #{ref_no} - no issues")
                        _slack.send
                        email.read!
                    else
                        email_message = email.message.text_part.body.decoded
                        index = email_message.index("Transaction ID")
                        transaction_id =  email_message[index+14...index+30].split(" ").last
                        AutoApproveWorker.perform_async ref_no,transaction_id
                        email.read!
                    end
                end
            else
                email.read!
            end
        end
    end
end