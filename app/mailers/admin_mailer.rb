class AdminMailer < ApplicationMailer

    def new_user user, host, temp_pass
        @host = host
        @user = user
        @temp_pass = temp_pass
        mail(
            to: @user.email, 
            subject: "Drive-Through Admin - Set Password")
    end

    def add_campaign campaign
        @campaign = campaign
        _bcc = ENV["CC_MAIL"].split("|")
        _bcc.each do |recipient|
            mail(to:recipient, subject: "New Campaign Details")
        end 
    end
end