class AdminMailer < ApplicationMailer

    def new_user user, host, temp_pass
        @host = host
        @user = user
        @temp_pass = temp_pass
        mail(
            to: "zubiri.jem@gmail.com", 
            cc: ENV["CC_MAIL"].split("|"),
            subject: "Drive-Through Admin - Set Password")
    end

end