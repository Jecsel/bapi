class V1::ClinicController < ApplicationController
    
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
        params.require(:clinic).permit(:name, :code)
    end

end
