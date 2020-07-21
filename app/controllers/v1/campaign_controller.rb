class V1::CampaignController < ApplicationController
    before_action :must_be_authenticated


    def index
       in_charge = Campaign.in_charges.map{ |a| {id: a.second, name: a.first} } #Get enum values
       render json: in_charge 
    end

    def create
        campaign = Campaign.create create_campaign_params
        render json: :created
    end

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

    def create_campaign_params
        params.require(:campaign).permit(:event_name, :campaign_client_id, :campaign_company_id, :campaign_billing_id, 
            :campaign_doctor_id, :campaign_site, :campaign_start_date, :campaign_end_date, :campaign_start_time, :campaign_end_time,
            :package, :optional_test, :est_pax, :need_phleb, :no_of_phleb, :remarks, :report_management, :onsite_pic_name,
            :onsite_pic_contact, :in_charge, :status)
    end
    
    def data_search
        AuditLog.search_filter(filter_params)
    end
end