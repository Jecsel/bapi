class V1::CampaignController < ApplicationController
    before_action :must_be_authenticated


    def index
       in_charge = Campaign.in_charges.map{ |a| {id: a.second, name: a.first} } #Get enum values
       render json: in_charge 
    end

    def create
        campaign = Campaign.new(create_campaign_params.merge(created_by: @current_user.username))
        if campaign.save
            AdminMailer.add_campaign(campaign).deliver_later
            render json: :created
        else
            render json: campaign.errors.full_messages.first
        end
    end

    def update
        @campaign = Campaign.find(params[:id])
        if @campaign.present?
            @campaign.update create_campaign_params
            @campaign.update updated_by: @current_user.username
        end
    end

    def show
        @campaign = Campaign.find params[:id]
    end

    def filter 
        @campaign = Campaign.page(filter_params[:page]).order(campaign_start_date: :asc)
        # Campaign.page(1)
        # @campaign = data_search.page(filter_params[:page]).order(created_at: :desc)
    end

    def upload_participant
        campaign = Campaign.find request.headers['x-campaign-id'].to_i
        
        valid_headers = ["Full Name", "DOB (yyyymmdd)", "Gender", "IC/Passport Number",	"Mobile Number", "Email Address", "Staff ID", "Department",	"Barcode"]

        xlsx = Roo::Spreadsheet.open(params[:files][0].tempfile)
        participants = xlsx.sheet(0).parse(fullname: "Full Name", date_of_birth: "DOB (ddmmyyyy)", 
            gender: "Gender", id_number: "IC/Passport Number", mobile: "Mobile Number", 
            email: "Email Address", staff_id: "Staff ID", department: "Department", barcode: "Barcode", clean: true) #Removes whitespaces

        participants.each do |participant|
            next if participant[:fullname] == nil || participant[:date_of_birth] == nil || #If either are nil, skip record
            participant[:date_of_birth].to_s.length != 8 #Skip records that doesn't have fullname / odb
            if check_date(participant[:date_of_birth].to_s)
                p 'pasok'
                # p participant[:date_of_birth]
            else
                p "INVALID DATE"
            end
        end

        
        # campaign.upload_document.attach(params[:files][0])
        # if history.save
        #     history.upload_document.attach(params[:files][0])
        # end
        render json: :uploaded
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


    def check_date date_string
        year = date_string[0..3].to_i 
        day = date_string[4..5].to_i
        month = date_string[6..7].to_i
        

        if day > 31 || month > 12 || year > 2020 #Check if digits are valid
            return false
        else
            date = (day.to_s + "/" + month.to_s + "/" + year.to_s)
            begin
                parsedDate = Date.parse(date)
                p '========='
                p parsedDate
                return true
            rescue
                return false
            end

            
        end
    end

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
            :onsite_pic_contact, :in_charge, :status, :created_by, :updated_by)
    end
    
    def data_search
        AuditLog.search_filter(filter_params)
    end
end