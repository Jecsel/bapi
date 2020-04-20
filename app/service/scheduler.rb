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
        @allocation_per_slot    = schedule_params[:allocation_per_slot]
        @minutes_interval       = schedule_params[:minutes_interval]
        @afternoon              = schedule_params[:afternoon]
        @morning                = schedule_params[:morning]
        
        # validate()
        generate_schedule
    end
    private
    def  generate_schedule
        dates = date_to.blank? ? [date_from] : (date_from..date_to).to_a
        p "***********************"
        p "Generating"
        p dates
        p "***********************"
        
    end
    
end