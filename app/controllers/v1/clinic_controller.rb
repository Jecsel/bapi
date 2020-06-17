class V1::ClinicController < ApplicationController
    before_action :must_be_authenticated

    def filter 
        @clinics = Clinic.where(status:filter_params[:status]).search(filter_params[:search_str]).page(filter_params[:status]).order('id desc')
    end
    def list 
        @clinics = Clinic.order('id desc')
    end
    def index
        
    end
    
    def create
        clinic = Clinic.create clinic_params
        AuditLog.log_changes("Clinics", "clinic_id", clinic.id, "", "", 0, @current_user.username)
        render json:{data:clinic,message: :created}
    end
    def destroy 
    end
    
    def show
        @clinics = Clinic.find params[:id]
        @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",3) #Clinic service
    end
   
    def update
        @clinics = Clinic.find(params[:id])
        AuditLog.log_changes("Clinics", "clinic_id", @clinics.id, "", "", 1, @current_user.username)
        @clinics.update clinic_params
    end

    def paginate
        @clinics_page = Clinic.page(params[:page]).order('id desc')
    end

    private 
    def clinic_params
        params.require(:clinic).permit(:name, :code, :email_address, :contact_number, :address, :contact_person, :billing_code, :status, :clinic_area_id)
    end

    def filter_params
        params.require(:filter).permit(:page, :status, :search_str)
    end

end
