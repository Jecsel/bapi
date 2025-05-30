class V1::Guest::LocationController < ApplicationController

    
    def areas 
        loc = Location.active.find params[:location_id]
        area_ids = loc.clinics.pluck(:clinic_area_id)
        @areas = ClinicArea.where(id: area_ids).order(name: :asc)
    end     
    
    def clinic_area
        loc = Location.active.find area_params[:location_id]
        @clinics = loc.clinics
        selected_clinic_area = @clinics.where(clinic_area_id: area_params[:area_code], status: true).order(name: :asc)
        render json:selected_clinic_area
    end

    def find_schedules
        booking_date_range = Setting.last.booking_date_range
        @loc = Location.find params[:location_id]
        @schedule = @loc.schedules.find(params[:scheduled_id])
    end
    
    def schedules
        today = DateTime.now.in_time_zone
        two_weeks_from_now = today.beginning_of_day + 14.days
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where(schedule_date:[cut_off_time..two_weeks_from_now]).available.order(schedule_date: :asc)
    end

    
    def index
        @locations = Location.active.all
    end

    def area_params
        params.permit(:location_id, :area_code)
    end

    private
    def cut_off_time
        today = DateTime.now.in_time_zone
        return today < today.beginning_of_day + 17.hours ? today + 1.day : today + 2.day
    end
end
