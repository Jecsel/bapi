class AdminMailer < ApplicationMailer

    def new_user user, host, temp_pass
        @host = host
        @user = user
        @temp_pass = temp_pass
        mail(
            to: @user.email, 
            subject: "Drive-Through Admin - Set Password")
    end

    def self.add_campaign campaign
        # @campaign = campaign
        _bcc = ENV["CAMPAIGN_CONTACT"].split("|")
        _bcc.each do |recipient|
            send_campaign_details(recipient, campaign).deliver_later
        end 
    end

    def send_campaign_details recipient, campaign
        @campaign = campaign
        mail(to:recipient, subject: "New Campaign Details")
    end
end