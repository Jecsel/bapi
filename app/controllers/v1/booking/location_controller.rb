class V1::Booking::LocationController < ApplicationController


    def schedules
        today = Date.today
        @loc = Location.find params[:location_id]
        @_schedules = @loc.schedules.where("schedule_date >= ?",today)
    end
    def index
        @locations = Location.all
    end

end
