class V1::ClinicController < ApplicationController
    
    def create
        Clinic.create clinics_params
        render json:{message: :created}
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
