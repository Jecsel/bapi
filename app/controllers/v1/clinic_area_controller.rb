class V1::ClinicAreaController < ApplicationController
    before_action :must_be_authenticated, except: [:index]
    # def index 
    #     @areas = ClinicArea.active.order(:name)
    # end
    def create
        area = ClinicArea.where("name = ?", create_params[:name])
        if area.any?
            render json: {message:"Area already exists in the dropdown list."},status:403
        else
            area = ClinicArea.create create_params
            render json: area
        end
        
    end
    private 
    def create_params
        params.require(:area).permit(:name)
    end
end
