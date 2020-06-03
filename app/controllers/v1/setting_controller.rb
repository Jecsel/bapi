class V1::SettingController < ApplicationController
    before_action :must_be_authenticated, except: [:index]

    def index
        @setting = Setting.last
        render json: @setting
    end
    def update
        @setting = Setting.last
        if @setting.nil?
            @setting = Setting.create covid_price:0
        end
        case setting_params[:type]
            when 1
                @setting.update covid_price:setting_params[:new_value]
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
