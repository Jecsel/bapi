class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
        PaymentWorker.perform_async params[:RefNo]
        render html: :RECEIVEOK,status:200
    end
    
    def status
        @data = params
    end
    
end
