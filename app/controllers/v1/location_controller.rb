class V1::LocationController < ApplicationController
  
  before_action :must_be_authenticated
  before_action :get_location, only:[:add_clinic, :clinics, :schedules]

  def schedules 
    today = Date.today
    @schedules = Schedule.where("location_id = ? && schedule_date > ?",params[:location_id], today)
  end

  def clinics
    @clinics = @location.clinics
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

  def show
    @location = Location.find params[:id]
  end
  def destroy 
    Location.find(params[:id]).update(status: false)
    render json: {message: :deleted}
  end 

  def index
    @locations = Location.active.all
  end
  
  def create
    data = Location.create location_params
    render json: {data:data,message: :created}
  end

  def update
    Location.find(params[:id]).update location_params
    render json: {message: params}
  end
  private 
  def get_location
    @location = Location.find params[:location_id]
  end
  def location_params
    params.require(:location).permit(:name, :address, :longitude, :latitude, :code)
  end
end
