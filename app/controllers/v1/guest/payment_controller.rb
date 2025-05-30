class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
        filename = "post_payload_#{Time.now.to_i}"
        _s3 = S3Bucket.new 
        _s3.upload request.body,filename

        ref_no  = params[:RefNo]
        pay     = Payment.find_by_ref_no ref_no

        hist            = pay.payment_histories.new
        hist.trans_id   = payment_params[:TransId]
        hist.auth_code  = payment_params[:AuthCode]
        hist.signature  = payment_params[:Signature]
        hist.ccname     = payment_params[:CCName]
        hist.ccno       = payment_params[:CCNo]
        hist.s_bankname = payment_params[:S_bankname]
        hist.s_country  = payment_params[:S_country]
        hist.amount     = payment_params[:Amount]
        hist.payment_reference = payment_params[:TransId]
        hist.s3_artifact = filename
        hist.save
        PaymentWorker.perform_async pay.id,hist.id, payment_params[:PaymentId]
        render html: :RECEIVEOK,status:200
    end
    
    def status
        @data = payment_params
        @booking = Booking.where("reference_code = ?",payment_params[:RefNo]).last
    end
    
    private
    def payment_params
        params.permit(:RefNo, :TransId, :AuthCode, :Signature, :CCName, :CCNo, :S_bankname, :S_country, :PaymentId, :Amount, :Status)
    end
end
