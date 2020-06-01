class V1::BookingController < ApplicationController
    before_action :must_be_authenticated
    
    def confirm_manual_payment 
        payment = Payment.find_by_booking_id manual_payment_params[:booking_id]
        
        if payment.payment_histories.present?
            if !payment.payment_histories.last.upload_document.attached?
                render json: {message: "Please upload payment document"},status:404
                return false
            end
            ActiveRecord::Base.transaction do
                if payment.payment_histories.present?
                    payment.payment_histories.last.update payment_mode_id: :manual,payment_reference:manual_payment_params[:payment_reference],payment_date:manual_payment_params[:payment_date]
                    payment.update payment_status: :confirmed
                else
                    payment.payment_histories.create payment_mode_id: :manual,payment_reference:manual_payment_params[:payment_reference],payment_date:manual_payment_params[:payment_date]
                    payment.update payment_status: :confirmed
                end
            end
            render json: :approved
        else
            render json: {message: "Please upload payment document"},status:404
        end
    end

    def upload_document
        payment = Payment.find_by_booking_id request.headers['x-booking-id'].to_i
        history = payment.payment_histories.new
        
        if history.save
            history.upload_document.attach(params[:files][0])
        end

        render json: :uploaded
    end

    def export 
        @bookings = data_search.sort_by_datetime
    end

    def filter 
        @bookings = data_search.page(filter_params[:page]).sort_by_datetime
    end

    def index
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
        booking.update(schedule_id: params[:new_booking_details][:schedule][:id])
        booking.payment.update(payment_status: 1)

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

        render json: {
            schedule: booking.schedule, 
            slot: booking.slot, 
            slot_time_with_interval: booking.slot.slot_time.utc.strftime("%I:%M") + booking.slot.meridian + " - " + (booking.slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M") + booking.slot.meridian,
            payment_status: booking.payment.payment_status}
    end

    # def paginate
    #     if params[:location_id] != 0
    #         @bookings = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id]).page(params[:page])
    #         @booking_export = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id])
    #     else
    #         @bookings = Booking.search(params[:query]).get_status(params[:status_index]).page(params[:page])
    #         @booking_export = Booking.search(params[:query]).get_status(params[:status_index])
    #     end
        
        
    # end

    # def filter_booking
    #     if params[:location_id] != 0
    #         @bookings = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id]).page(1)
    #         @booking_export = Booking.search(params[:query]).get_status(params[:status_index]).get_site(params[:location_id])
    #     else
    #         @bookings = Booking.search(params[:query]).get_status(params[:status_index]).page(1)
    #         @booking_export = Booking.search(params[:query]).get_status(params[:status_index])
    #     end
       
    # end

    private 
    def data_search
        Booking
            .joins(:schedule,:payment)
            .search_filter(filter_params)
            .search(filter_params[:search_string])
    end
    def filter_params
        params
            .require(:filter)
            .permit(:location_id, :status, :booking_date_start, :booking_date_end, :page , :search_string)
    end
    def manual_payment_params 
        params.require(:payment).permit(:booking_id, :payment_reference, :payment_date)
    end
end
