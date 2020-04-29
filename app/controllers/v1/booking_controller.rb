class V1::BookingController < ApplicationController
    before_action :must_be_authenticated
    
    def index
        #Default get confirmed filter, get first page, get current datetime as search_start_date 
        @bookings = Booking.get_status(1).page(1)
        @locations = Location.all
        @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ?",4)
    end

    def show
        @booking = Booking.find params[:id]
    end

    def cancel_booking
        booking = Booking.find(params[:id])
        update_status = booking.payment.update(payment_status: 4)
        slot = booking.slot.increment!(:allocations, 1)
        slot_status = booking.slot.update(status: true)
        render json:{payment_status: 'cancelled'}
    end

    def mark_no_show
        booking = Booking.find(params[:id]).payment.update(payment_status: 2)
        render json:{payment_status: 'missed'}
    end

    def mark_as_completed
        booking = Booking.find(params[:id]).payment.update(payment_status: 3)
        render json:{payment_status: 'completed'}
    end

    def edit_booking
        booking = Booking.find params[:past_booking_details][:id]
        booking.schedule.update(schedule_date: params[:new_booking_details][:schedule][:schedule_date])

        # Update old slod to be available
        old_slot = Slot.find params[:past_booking_details][:slot][:id]
        old_slot.increment!(:allocations, 1)
        old_slot.update(status: true)

        # Update new slot, add allocation and modify status
        new_slot = Slot.find params[:new_booking_details][:slot][:id]
        new_slot.decrement!(:allocations, 1)
        if new_slot[:allocations] == 0
            new_slot.update(status: false)
        end
        booking.update(slot_id: new_slot.id)

        render json: {schedule: booking.schedule, slot: booking.slot}
    end

    def paginate
        if params[:location_id] != 0
            @bookings = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id]).page(params[:page])
        else
            @bookings = Booking.search(params[:query]).get_status(params[:status_index]).page(params[:page])
        end
        
        # if params[:search_start_date] && params[:search_end_date]
        #     @bookings = Booking.joins(:schedule)
        #     .search(params[:query])
        #     .where("schedules.schedule_date >= ?" ,params[:search_end_date].to_datetime.beginning_of_day..params[:search_start_date].to_datetime.beginning_of_day)
        #     .joins(:slot).where("slots.slot_time >= ?", params[:search_start_date].to_datetime.utc.strftime("%H%M%S%N")..params[:search_end_date].strftime("%H%M%S%N"))
        #     .get_status(params[:status_index])
        #     .page(params[:page]) 
        # elsif params[:search_start_date]
        #     @bookings = Booking
        #     .joins(:schedule)
        #     .joins(:slot)
        #     .search(params[:query])
        #     .where("schedules.schedule_date >= ? AND slots.slot_time <= ?" ,Time.zone.parse(params[:search_start_date]).beginning_of_day,Time.zone.parse(params[:search_start_date]).strftime("%H%M%S%N"))
        #     .get_status(params[:status_index])
        #     .page(params[:page]) 
        #     # @bookings = Booking.joins(:schedule).joins(:slot).where("schedules.schedule_date >= ? AND slots.slot_time.strftime("%H%M%S%N") <= ?" ,Time.zone.parse("2020-04-28T15:35:00.000Z").beginning_of_day,Time.zone.parse("2020-04-28T15:35:00.000Z").strftime("%H%M%S%N")).get_status(1).page(1) 
        # elsif params[:search_end_date]
        #     @bookings = Booking.joins(:schedule)
        #     .search(params[:query])
        #     .where("schedules.schedule_date <= ?" ,params[:search_end_date].to_datetime.beginning_of_day)
        #     .joins(:slot).where("slots.slot_time <= ?",params[:search_end_date].to_datetime.utc.strftime("%H%M%S%N"))
        #     .get_status(params[:status_index])
        #     .page(params[:page]) 
        # else
        #     @bookings = Booking.search(params[:query])
        #     .search(params[:query])
        #     .get_status(params[:status_index])
        #     .page(params[:page]) 
        # end 
    end

    def filter_booking
        if params[:location_id] != 0
            @bookings = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id]).page(1)
        else
            @bookings = Booking.search(params[:query]).get_status(params[:status_index]).page(1)
        end
        # if params[:search_start_date] && params[:search_end_date]
        #     @bookings = Booking.joins(:schedule)
        #     .search(params[:query])
        #     .where("schedules.schedule_date >= ?" ,params[:search_end_date].to_datetime.beginning_of_day..params[:search_start_date].to_datetime.beginning_of_day)
        #     .joins(:slot).where("slots.slot_time >= ?", params[:search_start_date].to_datetime.utc.strftime("%H%M%S%N")..params[:search_end_date].strftime("%H%M%S%N"))
        #     .get_status(params[:status_index])
        #     .page(1) 
        # elsif params[:search_start_date]
        #     @bookings = Booking
        #     .joins(:schedule)
        #     .joins(:slot)
        #     .search(params[:query])
        #     .where("schedules.schedule_date >= ? AND slots.slot_time <= ?" ,Time.zone.parse(params[:search_start_date]).beginning_of_day,Time.zone.parse(params[:search_start_date]).strftime("%H:%M"))
        #     .get_status(params[:status_index])
        #     .page(1) 
        #     @bookings = Booking.joins(:schedule, :slot).where("schedules.schedule_date >= ? AND slots.slot_time <= ?" ,Time.zone.parse("2020-04-29T12:00:00.000Z").beginning_of_day,Time.zone.parse("2020-04-29T12:00:00.000Z").strftime("%H%M%S%N")).get_status(1).page(1) 
        # elsif params[:search_end_date]
        #     @bookings = Booking.joins(:schedule)
        #     .search(params[:query])
        #     .where("schedules.schedule_date <= ?" ,params[:search_end_date].to_datetime.beginning_of_day)
        #     .joins(:slot).where("slots.slot_time <= ?",params[:search_end_date].to_datetime.utc.strftime("%H%M%S%N"))
        #     .get_status(params[:status_index])
        #     .page(1) 
        # else
        #     @bookings = Booking.search(params[:query])
        #     .search(params[:query])
        #     .get_status(params[:status_index])
        #     .page(1) 
        # end 
    end
end
