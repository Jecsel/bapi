class ApplicationController < ActionController::API
    
    def ping
        render json: :pongssss
    end
end
