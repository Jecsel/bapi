class V1::Guest::LocationController < ApplicationController

    def clinics 
        loc = Location.active.find params[:location_id]
        @clinics = loc.clinics
    end

    def until
        self.slot_time +10.minutes
    end

    def find_schedules
        booking_date_range = Setting.last.booking_date_range
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("id = ? && schedule_date > ?",params[:scheduled_id],cut_off_time).order(schedule_date: :asc).limit(booking_date_range)
      
        data = @schedules.any? ? @schedules.last.slots.group_by(&:meridian) : []
        @data = data.map { |kev,val|
            {
                key: val.map { |slot|
                    {
                        id: slot.id,
                        schedule_id: slot[:schedule_id],
                        slot_time: slot.slot_time,
                        meridian: slot.meridian,
                        allocations: slot.allocations,
                        created_at: slot.created_at,
                        status: slot.status,
                        updated_at: slot.updated_at,
                        duration: slot.full_duration
                    }
                    
                }
            }
        }
    end
    
    def schedules
        booking_date_range = Setting.last.booking_date_range
        @loc = Location.find params[:location_id]
        @schedules = @loc.schedules.where("schedule_date > ?",cut_off_time).order(schedule_date: :asc).limit(booking_date_range)
    end
    
    def index
        @locations = Location.active.all
    end
    private
    def cut_off_time
        today = DateTime.now.in_time_zone
        return today < today.beginning_of_day + 17.hours ? today : today + 1.day
    end
end
