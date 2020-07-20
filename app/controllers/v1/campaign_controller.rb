class V1::CampaignController < ApplicationController
    before_action :must_be_authenticated


    def filter 
        @campaign = Campaign.page(filter_params[:page])
        # @campaign = data_search.page(filter_params[:page]).order(created_at: :desc)
    end

    def export
        # @audit_log = data_search.order(created_at: :desc)
    end



    def campaign_client
        campaign_client = CampaignClient.all
        render json: campaign_client.as_json(only: [:id, :name])
    end
    def campaign_company
        campaign_company = CampaignCompany.all
        render json: campaign_company.as_json(only: [:id, :name])
    end
    def campaign_billing
        campaign_billing = CampaignBilling.all
        render json: campaign_billing.as_json(only: [:id, :name])
    end
    def campaign_doctor
        campaign_doctor = CampaignDoctor.all
        render json: campaign_doctor.as_json(only: [:id, :code])
    end

    def add_campaign_client
        client = CampaignClient.where("name = ?", add_client_params[:name])
        if client.any?
            render json: {message:"Client already exists in the dropdown list."},status:403
        else
            client = CampaignClient.create add_client_params
            render json: client
        end
    end
    def add_campaign_company
        company = CampaignCompany.where("name = ?", add_company_params[:name])
        if company.any?
            render json: {message:"Company already exists in the dropdown list."},status:403
        else
            company = CampaignCompany.create add_company_params
            render json: company
        end
    end
    def add_campaign_billing
        billing = CampaignBilling.where("name = ?", add_billing_params[:name])
        if billing.any?
            render json: {message:"Billing already exists in the dropdown list."},status:403
        else
            billing = CampaignBilling.create add_billing_params
            render json: billing
        end
    end
    def add_campaign_doctor
        code = CampaignDoctor.where("code = ?", add_doctor_params[:code])
        if code.any?
            render json: {message:"Doctor code already exists in the dropdown list."},status:403
        else
            code = CampaignDoctor.create add_doctor_params
            render json: code
        end
    end

    private

    def filter_params
        params
            .require(:filter)
            .permit(:page)
    end

    def add_client_params
        params.require(:client).permit(:name)
    end
    def add_company_params
        params.require(:company).permit(:name)
    end
    def add_billing_params
        params.require(:billing).permit(:name)
    end
    def add_doctor_params
        params.require(:doctor).permit(:code)
    end
    def data_search
        AuditLog.search_filter(filter_params)
    end
end