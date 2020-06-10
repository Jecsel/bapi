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
        @schedules = @loc.schedules.where("id = ? && schedule_date > ?",params[:scheduled_id],cut_off_time).available.order(schedule_date: :asc).limit(booking_date_range)
        render json:{
            active_slot:{
                status: @schedules.any?,
                data: @schedules.first.slots.group_by(&:meridian).as_json(
                    methods: [:slot_time_with_interval]
                )
            },
            schedules: @schedules.as_json(only: [:id, :schedule_date], methods:[:has_available_slot])
        }
    end
    
    def schedules
        booking_date_range = Setting.last.booking_date_range
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("schedule_date > ?",cut_off_time).available.order(schedule_date: :asc).limit(booking_date_range)

        render json:{
            id: @loc.id, 
            name: @loc.name,
            address: @loc.address,
            active_slot:{
                status: @schedules.any?,
                data: @schedules.first.slots.group_by(&:meridian).as_json(
                    methods: [:slot_time_with_interval]
                )
            },
            schedules: @schedules.as_json(only: [:id, :schedule_date], methods:[:has_available_slot])
        }
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
        return today < today.beginning_of_day + 17.hours ? today : today + 1.day
    end
end
