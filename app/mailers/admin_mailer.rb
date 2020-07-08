class AdminMailer < ApplicationMailer

    def new_user user, host, temp_pass
        @host = host
        @user = user
        @temp_pass = temp_pass
        mail(
            to: @user.email, 
            subject: "Drive-Through Admin - Set Password")
    end

end