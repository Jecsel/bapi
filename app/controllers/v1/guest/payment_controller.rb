class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
        render json: :accepted,status:200
        # @data = params
    end
    
    def status
        @data = params
    end
    
end
