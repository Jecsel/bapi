class V1::SettingController < ApplicationController
    before_action :must_be_authenticated, except: []

    def index
        @setting = Setting.last
        role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",6).extract_associated(:service_policy)
        histories = @setting.setting_histories.where("setting_type = ?",1)
        if histories.any?
            render json: {
                setting:@setting,
                price_updated_by:histories.last.user.username, 
                price_updated_date:histories.last.created_at,
                controls: role_policy }
        else
            render json: {setting:@setting, controls: role_policy}
        end
    end
    def update
        @setting = Setting.last
        if @setting.nil?
            @setting = Setting.create covid_price:0
        end
        old_value = @setting.covid_price
        case setting_params[:type]
            when 1
                if old_value.to_f != setting_params[:new_value].to_f
                    @setting.setting_histories.create(
                        user_id:@current_user.id, 
                        setting_type:setting_params[:type],
                        old_value: @setting.covid_price,
                        new_value: setting_params[:new_value]
                    )
                    @setting.update covid_price:setting_params[:new_value]
                    AuditLog.log_changes("Settings", "covid_price", @setting.id, old_value, @setting.covid_price, 1, @current_user.username)
                    render json: {message:"Price updated successfully"}
                else
                    render json: {message:"This is the current price. No update required."}
                end
            when 2
                @setting.setting_histories.create(
                    user_id:@current_user.id, 
                    setting_type:setting_params[:type],
                    old_value: @setting.booking_date_range,
                    new_value:setting_params[:new_value]
                )
                @setting.update booking_date_range:setting_params[:new_value]
                render json: {message:"Booking range updated"}
        end
        
    end

    private
    def setting_params
        params.require(:setting).permit(:new_value, :type)
    end
end
