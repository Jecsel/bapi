class V1::AuditController < ApplicationController
    before_action :must_be_authenticated

    def index
        @audit_log = AuditLog.page(1).order(created_at: :desc)
    end
    

    def filter 
        @audit_log = AuditLog.page(filter_params[:page]).order(created_at: :desc)
    end


    private
    def filter_params
        params
            .require(:filter)
            .permit(:page)
    end
end