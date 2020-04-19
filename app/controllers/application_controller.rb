class ApplicationController < ActionController::API
    
    def _must_be_authenticated
        client = Authentication.new request.headers['x-biomark-group']
        begin
            res = client.validate_token request.headers['x-access-token']
            @current_user = User.find_by_uuid res[0]["username"]
        rescue => e
            invalid_session
        end  
    end

    def _initialize_doctor
        @doctor = Doctor.new @current_user
    end
    def not_found
        render json:{message:"Not found"},status:404
    end
    def invalid_account
        render json: {message:"Invalid Username or Password"},status:401
    end

    def invalid_session
        render json: {message:"Invalid Session"},status:401
    end

    def ping
        render json: :pongssss
    end
end
