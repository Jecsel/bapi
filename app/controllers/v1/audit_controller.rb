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
    end

    private
    def filter_params
        params
            .require(:filter)
            .permit(:page, :audit_date_start, :audit_date_end, :module_type, :user_id)
    end
    def data_search
        AuditLog.search_filter(filter_params)
    end
end