class V1::ScheduleController < ApplicationController
    before_action :must_be_authenticated

    def destroy 
        schedule = Schedule.find(params[:id])
        schedule.update status:false
        schedule.slots.update_all status:false
        AuditLog.log_changes("Test Sites", "location_delete_day", schedule.id, "", schedule.schedule_date, 3, @current_user.username)
        render json: :deleted
    end

    def close_slot
        _schedule = Schedule.find params[:schedule_id]
        slot = _schedule.slots.find params[:slot_id]
        slot.update is_deleted:true
        AuditLog.log_changes("Test Sites", "location_delete_slot", _schedule.id, _schedule.schedule_date, slot.slot_time.utc.strftime("%I:%M") + slot.meridian + " - " + (slot.slot_time + _schedule.minute_interval*60).utc.strftime("%I:%M") + slot.meridian, 3, @current_user.username)
        render json: :closed
    end
    def slot
        _schedule = Schedule.find params[:schedule_id]
        @_slot = _schedule.slots.find params[:slot_id]
        @booking_count = Booking.where("slot_id = ?",params[:slot_id]).count
        @status = ""
        if @_slot.status
            @status = "Active"
        else
            if @_slot.allocations == 0
                @status = "Fully Booked"
            else
                @status = "Deleted"
            end
        end
        
    end
    def index 
    end
    def show
        @schedule = Schedule.find params[:id]
    end
    def create
        begin
            Scheduler.new schedule_params 
            AuditLog.log_changes("Test Sites", "location_add_schedule", "", "", get_log_text(), 0, @current_user.username)
            render json: {message: :generated, status:true}
        rescue=>ex
            render json: {message:ex,status:false},status:403
        end
    end

    private

    def get_log_text
        header = "Added new schedule "
        date = "date from #{schedule_params[:date_from].to_date.strftime("%d %A %Y")} to #{schedule_params[:date_to].to_date.strftime("%d %A %Y")}, "
        
        allowed_days = schedule_params[:days].map { |x| x[:is_selected] ? x[:name]: '' }.map(&:inspect).join(' ').gsub!('"', '').squish
        days = "day: #{allowed_days}, "

        slot_size = "slot size: #{schedule_params[:allocation_per_slot]}, "
        slot_duration = "slot duration(mins): #{schedule_params[:minutes_interval]}, "
        no_of_session = "no. of session: #{schedule_params[:no_of_session]}, "
        first_session = "first session #{schedule_params[:first_session][:start][:hh]}:#{schedule_params[:first_session][:start][:mm]} to #{schedule_params[:first_session][:end][:hh]}:#{schedule_params[:first_session][:end][:mm]}"
        first_session += ", " if schedule_params[:no_of_session] == 2
        second_session = "second session #{schedule_params[:second_session][:start][:hh]}:#{schedule_params[:second_session][:start][:mm]} to #{schedule_params[:second_session][:end][:hh]}:#{schedule_params[:second_session][:end][:mm]}" if schedule_params[:no_of_session] == 2
        log_text = header + date + days + slot_size + slot_duration + no_of_session + first_session
        log_text += second_session if schedule_params[:no_of_session] == 2
        log_text
    end

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
                :id,
                :name
            ]
        )
    end
end
