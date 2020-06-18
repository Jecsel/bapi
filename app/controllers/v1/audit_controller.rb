class V1::AuditController < ApplicationController
    before_action :must_be_authenticated

    def index
        @audit_log = AuditLog.page(1).order(created_at: :desc)
        @users = User.all
    end

    def filter 
        # @audit_log = AuditLog.page(filter_params[:page]).order(created_at: :desc)
        @audit_log = data_search.page(filter_params[:page]).order(created_at: :desc)
    end

    def export
        @audit_log = data_search.order(created_at: :desc)
        AuditLog.log_changes("AuditLogs", "audit_export", "", "", get_log_text(), 2, @current_user.username)
    end

    private

    def get_log_text
        header = "Exported CSV with filters "
        log_module = "module: #{filter_params[:module_type] == 0? "All modules" : Service.find(filter_params[:module_type]).name}, "
        log_user = "username: #{filter_params[:user_id] == 0? "All users" : User.find(filter_params[:user_id]).username}, "
        log_date = "date from #{filter_params[:audit_date_start].to_date.strftime("%d %B %Y")} to #{filter_params[:audit_date_end].to_date.strftime("%d %B %Y")}"

        log_text = header + log_module + log_user + log_date
        log_text
    end

    def filter_params
        params
            .require(:filter)
            .permit(:page, :audit_date_start, :audit_date_end, :module_type, :user_id)
    end
    def data_search
        AuditLog.search_filter(filter_params)
    end
end