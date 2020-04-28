class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
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
        hist.save
        PaymentWorker.perform_async pay.id,hist.id, payment_params[:PaymentId]
        render html: :RECEIVEOK,status:200
    end
    
    def status
        @data = params
    end
    
    private
    def payment_params
        params.permit(:RefNo, :TransId, :AuthCode, :Signature, :CCName, :CCNo, :S_bankname, :S_country, :PaymentId, :Amount)
    end
end
