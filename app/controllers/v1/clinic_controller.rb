class V1::ClinicController < ApplicationController
    before_action :must_be_authenticated
    
    def index
        @clinics = Clinic.all
    end
    
    def create
        clinic = Clinic.create clinic_params
        render json:{data:clinic,message: :created}
    end
    def destroy 
    end
    def show
    end
    def update
    end

    private 
    def clinic_params
        params.require(:clinic).permit(:name, :code, :email_address, :contact_number, :address, :contact_person, :billing_code, :status, :clinic_area_id)
    end

end
