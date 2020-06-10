class V1::ScheduleController < ApplicationController
    before_action :must_be_authenticated

    def destroy 
        schedule = Schedule.find(params[:id])
        schedule.update status:false
        schedule.slots.update_all status:false
        render json: :deleted
    end

    def close_slot
        _schedule = Schedule.find params[:schedule_id]
        slot = _schedule.slots.find params[:slot_id]
        slot.update status:false
        render json: :closed
    end
    def slot
        _schedule = Schedule.find params[:schedule_id]
        @_slot = _schedule.slots.find params[:slot_id]
        @_bookings = @_slot.bookings
    end
    def index 
    end
    def show
        @schedule = Schedule.find params[:id]
    end
    def create
        begin
            Scheduler.new schedule_params 
            render json: {message: :generated, status:true}
        rescue=>ex
            render json: {message:ex,status:false},status:403
        end
    end

    private

    def schedule_params
        params.require(:schedule).permit(
            :location_id,
            :date_from, 
            :date_to, 
            :allocation_per_slot, 
            :minutes_interval,
            :no_of_session,
            :first_session=>[
                :start=>[:hh, :mm], 
                :end=>[:hh, :mm]
            ],
            :second_session=>[
                :start=>[:hh, :mm], 
                :end=>[:hh, :mm]
            ],
            :days =>[
                :is_selected,
                :id
            ]
        )
    end
end
