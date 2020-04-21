class PatientBooking
    attr_accessor   :location_id,
                    :slot_id,
                    :schedule_id,
                    :patient

    def initialize booking_params
        @location_id    = booking_params[:location][:id]
        @slot_id        = booking_params[:slot][:id]
        @schedule_id    = booking_params[:schedule][:id] 
        @patient        = booking_params[:patient]
        
        generate_guest_profile
    end

    private 

    def generate_guest_profile
        
    end
end