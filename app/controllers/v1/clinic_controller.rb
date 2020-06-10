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
        render json: {clinic: clinics}
    end
    def update
    end

    def paginate
        @clinics_page = Clinic.page(params[:page]).order('id desc')
    end

    private 
    def clinic_params
        params.require(:clinic).permit(:name, :code, :email_address, :contact_number, :address, :contact_person, :billing_code, :status, :clinic_area_id)
    end

end
