class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
        render json: :RECEIVEOK,status:200
    end
    
    def status
        @data = params
    end
    
end
