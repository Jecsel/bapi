class V1::SettingController < ApplicationController
    before_action :must_be_authenticated

    def index
        @setting = Setting.last
        render json: @setting
    end
    def update
        @setting = Setting.last
        if @setting.nil?
            @setting = Setting.create covid_price:0
        end
        old_value = @setting.covid_price
        case setting_params[:type]
            when 1
                @setting.update covid_price:setting_params[:new_value]
                AuditLog.log_changes("Settings", "covid_price", @setting.id, old_value, @setting.covid_price, 1, @current_user.username)
            when 2
                @setting.update booking_date_range:setting_params[:new_value]
        end
        render json: :saved
    end

    private
    def setting_params
        params.require(:setting).permit(:new_value, :type)
    end
end
