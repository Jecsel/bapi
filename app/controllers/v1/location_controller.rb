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
    if params[:search_referral] != nil && params[:search_status] != nil
      @locations = Location
      .search(params[:search_string])
      .get_status(params[:search_status])
      .get_referral(params[:search_referral])
      .page(1)
    elsif params[:search_referral] != nil && params[:search_status] == nil
      @locations = Location
      .search(params[:search_string])
      .get_referral(params[:search_referral])
      .page(1)
    elsif params[:search_referral] == nil && params[:search_status] != nil
      @locations = Location
      .search(params[:search_string])
      .get_status(params[:search_status])
      .page(1)
    else
      @locations = Location
      .search(params[:search_string]) 
      .page(1)
    end
  end

  def paginate
    if params[:search_referral] != nil && params[:search_status] != nil
      @locations = Location
      .search(params[:search_string])
      .get_status(params[:search_status])
      .get_referral(params[:search_referral])
      .page(params[:page]).order(created_at: :desc)
    elsif params[:search_referral] != nil && params[:search_status] == nil
      @locations = Location
      .search(params[:search_string])
      .get_referral(params[:search_referral])
      .page(params[:page]).order(created_at: :desc)
    elsif params[:search_referral] == nil && params[:search_status] != nil
      @locations = Location
      .search(params[:search_string])
      .get_status(params[:search_status])
      .page(params[:page]).order(created_at: :desc)
    else
      @locations = Location
      .search(params[:search_string]) 
      .page(params[:page]).order(created_at: :desc)
    end
  end

  def add_clinic
    clinic = @location.location_clinics.where("clinic_id = ?",params[:clinic_id])
    if clinic.any?
      render json: {message: "Clinic already associated with this location"},status:406 
    else
      @location.location_clinics.create clinic_id:params[:clinic_id]
      render json: Clinic.find(params[:clinic_id])
    end
  end

  def unlink_clinic
    location = Location.find params[:location_id]
    clinic = location.location_clinics.where("clinic_id = ?",params[:clinic_id])
    if clinic.any?
      clinic.last.delete
      render json: {message: "Clinic was been unlink with this location"},status:200
    else
      render json: {message: "No Clinic associated with this location"},status:406 
    end
  end

  def show
    @location = Location.find params[:id]
  end
  def destroy 
    Location.find(params[:id]).update(status: false)
    render json: {message: :deleted}
  end 

  def index
    @locations = Location.page(1).order(created_at: :desc)
  end
  
  def create
    @location = Location.create location_params
  end

  def update
    @location = Location.find(params[:id])
    @location.update location_params
    @location
  end
  private 
  def get_location
    @location = Location.find params[:location_id]
  end
  def location_params
    params.require(:location).permit(:name, :address, :longitude, :latitude, :code, :status, :referral_type)
  end
end
