class V1::LocationController < ApplicationController
  
  before_action :must_be_authenticated
  
  def schedules 
    @schedules = Schedule.where("location_id = ?",params[:location_id])
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
end
