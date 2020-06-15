class V1::LocationController < ApplicationController
  
  before_action :must_be_authenticated
  before_action :get_location, only:[:add_clinic, :clinics, :schedules]

  def schedules 
    today = Date.today
    @schedules = Schedule.where("location_id = ? && schedule_date >= ?",params[:location_id], today).available.order(schedule_date: :asc).page(params[:page])
  end

  def clinics
    @clinics = @location.clinics
  end

  def filter
    @locations = Location.search_filter(filter_params).page(filter_params[:page])
  end

  def add_clinic
    clinic = @location.location_clinics.where("clinic_id = ?",params[:clinic_id])
    if clinic.any?
      render json: {message: "Clinic already associated with this location"},status:406 
    else
      @location.location_clinics.create clinic_id:params[:clinic_id]
      AuditLog.log_changes("Locations", "location_clinic_link", @location.id, "", params[:clinic_id], 4, @current_user.username)
      render json: Clinic.find(params[:clinic_id])
    end
  end

  def unlink_clinic
    location = Location.find params[:location_id]
    clinic = location.location_clinics.where("clinic_id = ?",params[:clinic_id])
    if clinic.any?
      AuditLog.log_changes("Locations", "location_clinic_link", params[:location_id], "", params[:clinic_id], 5, @current_user.username)
      clinic.last.delete
      render json: {message: "Clinic has been unlinked with this location"},status:200
    else
      render json: {message: "No Clinic associated with this location"},status:406 
    end
  end

  def show
    @location = Location.find params[:id]
    @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ? ",2) #Test site service
  end
  
  # def destroy 
  #   Location.find(params[:id]).update(status: false)
  #   render json: {message: :deleted}
  # end 
  
  def create
    @location = Location.create location_params
    AuditLog.log_changes("Locations", "location_id", @location.id, "", "", 0, @current_user.username)
  end

  def update
    @location = Location.find(params[:id])
    AuditLog.log_changes("Locations", "location_id", @location.id, "", "", 1, @current_user.username)
    @location.update location_params
    @location
  end

  private 

  def filter_params 
    params.require(:filter).permit(:status, :referral, :page, :search_str)
  end
  def get_location
    @location = Location.find params[:location_id]
  end
  def location_params
    params.require(:location).permit(:name, :address, :longitude, :latitude, :code, :status, :referral_type)
  end
end
