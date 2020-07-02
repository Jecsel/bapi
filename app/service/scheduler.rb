class Scheduler
    attr_accessor :date_from, 
        :date_to, 
        :location_id, 
        :allocation_per_slot, 
        :minutes_interval,
        :second_session,
        :first_session,
        :no_of_session,
        :allowed_days,
        :_schedule
    def initialize schedule_params
        @allowed_days = []
        @date_from                  = schedule_params[:date_from].to_date
        @date_to                    = schedule_params[:date_to].to_date
        @location_id                = schedule_params[:location_id]
        @allocation_per_slot        = schedule_params[:allocation_per_slot].to_i
        @minutes_interval           = schedule_params[:minutes_interval].to_i
        @first_session              = schedule_params[:first_session]
        @second_session             = schedule_params[:second_session]
        @no_of_session              = schedule_params[:no_of_session]
        schedule_params[:days].each do |dd|
            @allowed_days << dd[:id] if dd[:is_selected]
        end
        generate_schedule
    end
    private
    def  generate_schedule
        # (1.month.ago.to_date..Date.today).map{ |date| date.strftime("%b %d") }
        # dates = date_to.blank? ? [date_from] : (date_from...date_to).to_a
        dates = (date_from..date_to).map{ |date| date.strftime("%Y-%m-%d") }
        
        if Schedule.where(location_id:location_id,schedule_date: dates,status:true).any?
            raise "Existing slots found. Please delete or reschedule the bookings before adding new slots."
        end
        
        ActiveRecord::Base.transaction do
            dates.each do |_date|
                p "####"
                p _date
                p "####"
                next unless allowed_days.include?(_date.to_date.strftime("%u").to_i)
                payload = {};
                payload[:location_id]               = location_id
                payload[:schedule_date]             = _date
                payload[:allocation_per_slot]       = allocation_per_slot
                payload[:minute_interval]           = minutes_interval
                payload[:morning_start_time]        = "#{first_session[:start][:hh]}:#{first_session[:start][:mm]}".to_time
                payload[:morning_end_time]          = "#{first_session[:end][:hh]}:#{first_session[:end][:mm]}".to_time
                payload[:no_of_session]             = no_of_session
                if payload[:morning_start_time] >= payload[:morning_end_time] 
                    raise "Please check your slot time settings."
                end
                if no_of_session == 2
                    payload[:afternoon_start_time]   = "#{second_session[:start][:hh]}:#{second_session[:start][:mm]}".to_time
                    payload[:afternoon_end_time]     = "#{second_session[:end][:hh]}:#{second_session[:end][:mm]}".to_time
                    if payload[:morning_end_time] >= payload[:afternoon_start_time] || payload[:afternoon_start_time] >= payload[:afternoon_end_time]
                        raise "Please check your slot time settings."
                    end
                end
                @_schedule = Schedule.create payload
                generate_slot @_schedule
            end

            if @_schedule.nil?
                raise "No slots created"
            end
            if @_schedule.slots.count == 0
                raise "No slots created"
                sched.destroy
            end
        end
    end

    def generate_slot sched 
        
        first_session_start_time = "#{first_session[:start][:hh]}:#{first_session[:start][:mm]}"
        first_session_end_time   = "#{first_session[:end][:hh]}:#{first_session[:end][:mm]}"
        morning     = time_calculator sched.id,first_session_start_time,first_session_end_time,"AM"

        Slot.create morning
        
        if no_of_session == 2
            second_session_end_timestart_time = "#{second_session[:start][:hh]}:#{second_session[:start][:mm]}"
            second_session_end_time   = "#{second_session[:end][:hh]}:#{second_session[:end][:mm]}"
            afternoon   = time_calculator sched.id,second_session_end_timestart_time,second_session_end_time,"PM"
            Slot.create afternoon
        end
        
    end

    def time_calculator id,start_time, end_time, a
        payload = []
        (start_time.to_time.to_i..(end_time.to_time - minutes_interval.minutes).to_i).step(minutes_interval.minutes) do |date|
            payload << {
                schedule_id:id,
                slot_time: (Time.at(date) + 8.hours).strftime("%H:%M:00"), #compensate the timezone
                status:true,
                allocations: allocation_per_slot,
                meridian: a
            }
        end
        return payload
    end
    
end