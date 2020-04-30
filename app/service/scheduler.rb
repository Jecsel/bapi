class Scheduler
    attr_accessor :date_from, 
        :date_to, 
        :location_id, 
        :allocation_per_slot, 
        :minutes_interval,
        :afternoon,
        :morning

    def initialize schedule_params
        @date_from              = schedule_params[:date_from]
        @date_to                = schedule_params[:date_to]
        @location_id            = schedule_params[:location_id]
        @allocation_per_slot    = schedule_params[:allocation_per_slot].to_i
        @minutes_interval       = schedule_params[:minutes_interval].to_i
        @afternoon              = schedule_params[:afternoon]
        @morning                = schedule_params[:morning]
        
        # validate()
        generate_schedule
    end
    private
    def  generate_schedule
        dates = date_to.blank? ? [date_from] : (date_from..date_to).to_a
        ActiveRecord::Base.transaction do
            dates.each do |_date|
                sched = Schedule.create(
                    location_id: location_id,
                    schedule_date:_date, 
                    allocation_per_slot:allocation_per_slot,
                    minute_interval: minutes_interval,
                    morning_start_time: "#{morning[:start]}:00".to_time,
                    morning_end_time: "#{morning[:end]}:00".to_time,
                    afternoon_start_time: "#{afternoon[:start]}:00".to_time,
                    afternoon_end_time: "#{afternoon[:end]}:00".to_time)
                generate_slot sched
            end
        end
    end

    def generate_slot sched
        morning     = time_calculator sched.id,@morning[:start].to_i , @morning[:end].to_i, "AM"
        afternoon   = time_calculator sched.id,@afternoon[:start].to_i,@afternoon[:end].to_i, "PM"
        Slot.create morning
        Slot.create afternoon
    end

    def time_calculator id,start , _end, n
        payload = []
        while start < _end
            ( 60 / minutes_interval ).floor.times do |a|
                payload << {
                    schedule_id:id,
                    slot_time:"#{start}:#{(a * minutes_interval).to_s.rjust(2,"0")}".to_time,
                    status:true,
                    allocations: allocation_per_slot,
                    meridian: n
                }
            end
            start+=1
        end
        return payload
    end
    
end