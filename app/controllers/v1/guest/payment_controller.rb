class V1::Guest::PaymentController < ApplicationController
    
    def confirmation
        @data = params
    end
    
    def status
        @data = params
    end
    
end
