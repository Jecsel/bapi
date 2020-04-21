class V1::LocationController < ApplicationController
  
  before_action :must_be_authenticated
  
  def schedules 
    @schedules = Schedule.where("location_id = ?",params[:location_id])
  end

  def location_clinics
    @location_clinics = LocationClinic.where("location_id = ?",params[:location_id])
  end

  def add_location_clinic
    if !LocationClinic.exists?(location_id: location_clinic_params[:location_id], clinic_id: location_clinic_params[:clinic_id])
      data = LocationClinic.create location_clinic_params
      render json: {data:{clinic_id: data.clinic.id, clinic_name: data.clinic.name},message: :success}
    else
      render json: {message: "Clinic already associated with this location"}
    end
  end

  def show
    @location = Location.find params[:id]
  end
  def destroy 
    Location.delete params[:id]
    render json: {message: :deleted}    
  end 

  def index
    @locations = Location.all
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
  def location_params
    params.require(:location).permit(:name, :address, :longitude, :latitude)
  end

  def location_clinic_params
    params.require(:location).permit(:location_id, :clinic_id)
  end
end
