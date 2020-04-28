class V1::Guest::LocationController < ApplicationController

    def clinics 
        loc = Location.find params[:location_id]
        @clinics = loc.clinics
    end
    def find_schedules
        booking_date_range = Setting.last.booking_date_range
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("id = ? && schedule_date > ?",params[:scheduled_id],today).limit(booking_date_range)
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
