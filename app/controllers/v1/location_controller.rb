class V1::LocationController < ApplicationController
  
  before_action :must_be_authenticated
  
  def index
    @locations = Location.all
  end
  
  def create
    Location.create location_params
    render json: {message: :created}
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
