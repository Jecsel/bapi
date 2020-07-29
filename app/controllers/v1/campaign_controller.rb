class V1::CampaignController < ApplicationController
    before_action :must_be_authenticated


    def index
       
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
        @campaign_participants = @campaign.campaign_participants.active.includes(:participant).order('participants.fullname ASC, participants.id ASC').page(1)
    end

    def filter 
        # @campaign = Campaign.page(filter_params[:page]).order(campaign_start_date: :asc)
        # # Campaign.page(1)
        @campaign = data_search.page(filter_params[:page]).order(created_at: :desc)
    end

    def upload_participant
        campaign = Campaign.find request.headers['x-campaign-id'].to_i
        campaign.upload_document.attach(params[:files][0])
        campaign.save

        records_added = 0
        not_added_names = []
        
        valid_headers = ["Full Name", "DOB (yyyymmdd)", "Gender", "IC/Passport Number",	"Mobile Number", "Email Address", "Staff ID", "Department",	"Barcode"]

        xlsx = Roo::Spreadsheet.open(params[:files][0].tempfile)
        begin 
            participants = xlsx.sheet(0).parse(fullname: "Full Name", date_of_birth: "DOB (yyyymmdd)", 
                gender: "Gender", id_number: "IC/Passport Number", mobile: "Mobile Number", 
                email: "Email Address", staff_id: "Staff ID", department: "Department", barcode: "Barcode", clean: true) #Removes whitespaces

            participants.each do |participant|
                participant[:date_of_birth] = participant[:date_of_birth].to_s.gsub(/\s+/, "") #Remove all whitespaces from dob
                participant[:fullname] = participant[:fullname].to_s

                if participant[:fullname] != nil && participant[:fullname] != "" && participant[:date_of_birth] != nil && participant[:date_of_birth] != "" && #If either are nil, skip record
                        participant[:date_of_birth].length == 8 #Skip records that doesn't have fullname / odb
                    if !validate_date(participant[:date_of_birth]).nil?

                        new_participant                 = Participant.new
                        new_participant.fullname        = validate_fullname(participant[:fullname])
                        new_participant.date_of_birth   = validate_date(participant[:date_of_birth])
                        new_participant.gender          = validate_gender(participant[:gender])
                        new_participant.id_number       = validate_id_number(participant[:id_number])
                        new_participant.mobile          = validate_mobile(participant[:mobile])
                        new_participant.email           = validate_email(participant[:email])
                        new_participant.staff_id        = validate_staff_id(participant[:staff_id])
                        new_participant.department      = validate_department(participant[:department])
                        new_participant.barcode         = validate_barcode(participant[:barcode])                   

                        if new_participant.save!
                            CampaignParticipant.create(campaign_id: campaign.id, participant_id: new_participant.id)
                            records_added += 1
                        end
                    else
                        not_added_names << participant[:fullname]
                    end
                else
                    not_added_names << participant[:fullname]
                end
            end
        rescue => e
            render json:{error: "Header(s) Not Found", headers: e},status: 403
            return
        end

        message = "Upload successful. #{records_added} participants added to campaign. #{not_added_names.length > 0 ? not_added_names.join(', ') + " records have been skipped." : ""} "

        render json: message
    end

    def delete_participant
        CampaignParticipant.where(campaign_id: params[:campaign_id], participant_id: params[:participant_id]).first.update(status: false)
        render json: :deleted
    end

    def paginate_participant
        @campaign_participants = CampaignParticipant.includes(:participant).where(campaign_id: params[:campaign_id]).page(params[:page]).order('participants.fullname ASC, participants.id ASC').active
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
    def campaign_incharge
        in_charge = InChargePerson.all
        render json: in_charge.as_json(only: [:id, :name])
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

    def add_campaign_incharge
        in_charge = InChargePerson.where("name = ?", add_incharge_params[:name])
        if in_charge.any?
            render json: {message:"In charge person already exists in the dropdown list."},status:403
        else
            in_charge = InChargePerson.create add_incharge_params
            render json: in_charge
        end
    end

    def generate_request_forms
        @template = FormGenerator.new(params).generate_gribbles_forms

        @encoded_string = Base64.encode64(@template.render)
        render json: {pdf_string: @encoded_string}
    end

    private


    def validate_date date_string
        year = date_string[0..3].to_i 
        month = date_string[4..5].to_i
        day = date_string[6..7].to_i

        if day > 31 || month > 12 || year > 2020 #Check if digits are valid
            return nil
        else
            date = (day.to_s + "/" + month.to_s + "/" + year.to_s)
            begin
                parsedDate = Date.parse(date) #Add 1990 and current date validation
                if ("01/01/1990".to_date.beginning_of_day..Date.today.end_of_day).cover?(parsedDate)
                    return parsedDate
                else
                    return nil
                end 
            rescue
                return nil
            end
        end
    end

    def validate_fullname fullname
        #Remove special characters from string. Cut length to 50 characters. Auto capitalize first character
        return fullname.gsub(/[^a-zA-Z 0-9]/, '').gsub(/\s/,'')[0..49].sub(/^./, &:upcase)
    end

    def validate_gender gender
        gender = gender.to_s.gsub(/\s+/, "").sub(/^./, &:upcase) #Remove whitespaces. Capitalize
        if gender.length == 1 
            if gender == "M" || gender == "F"
                return gender
            else
                return ""
            end
        else
            return ""
        end

    end

    def validate_id_number id_number
        return id_number = id_number.to_s.gsub(/[^a-zA-Z 0-9]/, '').gsub(/\s/,'-') #Remove special characters
            .gsub(/\s+/, "") #Remove whitespaces
            .upcase[0..13] #Uppercase all letters. Limit 14 characters
    end

    def validate_mobile mobile
        mobile = mobile.to_s.gsub(/\s+/, "") #Remove whitespaces

        if mobile.length >= 8 && mobile.length <= 15
            return mobile
        else 
            return ""
        end
    end

    def validate_email email
        return email.to_s.gsub(/\s+/, "")[0..49] #Remove whitespaces. Limit 50 characters
    end

    def validate_staff_id staff_id
        return staff_id.to_s.gsub(/\s+/, "")[0..49] #Remove whitespaces. Limit 50 characters
    end

    def validate_department department
        return department.to_s.gsub(/\s+/, "")[0..49] #Remove whitespaces. Limit 50 characters
    end

    def validate_barcode barcode
        barcode_regex = "^GE[a-zA-Z]{2}[0-9]{4}$"
        barcode = barcode.to_s.gsub(/\s+/, "") #Remove whitespaces

        if barcode.match(barcode_regex) #Save if barcode is valid
            return barcode
        else #Auto generate barcode when barcode is null then save to biomark_db.biomark_barcodes
            auto_gen = barcode_generate
            while !BiomarkBarcode.exists?(code: auto_gen)
                BiomarkBarcode.create(code: auto_gen)
                return auto_gen
            end
        end
    end

    def barcode_generate
        return 'GE'+[*('A'..'Z')].shuffle[0,2].join+[*('0'..'9')].shuffle[0,4].join
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
    def add_incharge_params
        params.require(:incharge).permit(:name)
    end

    def create_campaign_params
        params.require(:campaign).permit(:event_name, :campaign_client_id, :campaign_company_id, :campaign_billing_id, 
            :campaign_doctor_id, :campaign_site, :campaign_start_date, :campaign_end_date, :campaign_start_time, :campaign_end_time,
            :package, :optional_test, :est_pax, :need_phleb, :no_of_phleb, :remarks, :report_management, :onsite_pic_name,
            :onsite_pic_contact, :in_charge_person_id, :status, :created_by, :updated_by)
    end
    
    def data_search
        # AuditLog.search_filter(filter_params)
        Campaign.search_filter(filter_params).search(filter_params[:search_string])
    end

    def filter_params
        params
            .require(:filter)
            .permit(:page , :search_string, :status, :campaign_date_start_from, :campaign_date_start_to )
    end
end