class V1::ClinicController < ApplicationController
    before_action :must_be_authenticated

    def list 
        @clinics = Clinic.order('id desc')
    end
    def index
        @clinics = Clinic.page(1).order('id desc')
    end
    
    def create
        clinic = Clinic.create clinic_params
        render json:{data:clinic,message: :created}
    end
    def destroy 
    end
    
    def show
        clinics = Clinic.find params[:id]
        role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",3).extract_associated(:service_policy) #Clinic service
        render json: {clinic: clinics, controls: role_policy}
    end
   
    def update
        @clinics = Clinic.find(params[:id])
        @clinics.update clinic_params
        render json: {msg: 'update success'}
    end

    def paginate
        @clinics_page = Clinic.page(params[:page]).order('id desc')
    end

    private 
    def clinic_params
        params.require(:clinic).permit(:name, :code, :email_address, :contact_number, :address, :contact_person, :billing_code, :status, :clinic_area_id)
    end

end
