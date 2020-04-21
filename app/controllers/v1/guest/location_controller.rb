class V1::Guest::LocationController < ApplicationController

    def find_schedules
        today = Date.today
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("id = ? && schedule_date > ?",params[:scheduled_id],today)
        # render json: @schedules
    end
    def schedules
        today = Date.today
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("schedule_date > ?",today)
    end
    def index
        @locations = Location.all
    end

end
