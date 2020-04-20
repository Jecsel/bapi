class ApplicationController < ActionController::API
    SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

    def ping
        render json: :pongssss
    end

    def must_be_authenticated
        token = request.headers['x-access-token']
        error_403 if token.blank? || token == 0 || token == ""

        data = decode token

        @current_user = User.find(data["user_id"])
        error_403 if @current_user.nil?
        error_403 if @current_user.user_token != data["secret"]
        @current_user    
    end

    def error_403
        render json: {message:"Unauthorized",code:403},status:403
    end
    def encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end
    
    def decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    end
end
