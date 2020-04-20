class V1::ScheduleController < ApplicationController
    before_action :must_be_authenticated

    def create
        # begin
            c = Scheduler.new schedule_params 
            render json: {message: :generated, status:true}
        # rescue=>ex
        #     render json: {message:ex,status:false}
        # end
        
    end

    private

    def schedule_params
        params.require(:schedule).permit(
            :location_id,
            :date_from, 
            :date_to, 
            :allocation_per_slot, 
            :minutes_interval,
            :afternoon=>[:start, :end],
            :morning=>[:start, :end]
        )
    end
end
