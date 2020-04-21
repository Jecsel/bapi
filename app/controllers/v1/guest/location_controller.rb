class V1::Guest::LocationController < ApplicationController


    def schedules
        today = Date.today
        @loc = Location.find params[:location_id]
        @today_schedule = @loc.schedules.where("schedule_date = ?",today)
        @future_schedules = @loc.schedules.where("schedule_date >= ?",today)
        p "---"
        p @today_schedule
        p "---"
    end
    def index
        @locations = Location.all
    end

end
