class V1::BookingController < ApplicationController
    before_action :must_be_authenticated
    
    def confirm_manual_payment 
        payment = Payment.find_by_booking_id( manual_payment_params[:booking_id] )
        ActiveRecord::Base.transaction do
            
            if payment.payment_histories.present?
                payment.payment_histories.last.update payment_mode_id: manual_payment_params[:payment_mode],payment_reference:manual_payment_params[:payment_reference],payment_date:manual_payment_params[:payment_date],amount:manual_payment_params[:amount], approved_by:@current_user.username
                payment.update({payment_status: :confirmed,payment_type:1})
                #Log update of payment details
                AuditLog.log_changes("Bookings", "booking_id", payment.booking_id, "", "", 1, @current_user.username)
            else
                history = payment.payment_histories.new
                history.payment_mode_id = manual_payment_params[:payment_mode]
                history.payment_reference = manual_payment_params[:payment_reference]
                history.payment_date = manual_payment_params[:payment_date]
                history.amount = manual_payment_params[:amount]
                history.approved_by = @current_user.username
                history.save
                
                payment.update({payment_status: :confirmed,payment_type:1})
                #Log create of payment details
                AuditLog.log_changes("Bookings", "booking_id", payment.booking_id, "", "", 0, @current_user.username)
            end
            #Log update of payment status
            AuditLog.log_changes("Bookings", "booking_status", payment.booking_id, "", "", 1, @current_user.username)
        end
        # BookingMailer.manual_confirmation(payment.booking_id).deliver_later
        BookingMailer.reservation(payment.booking_id).deliver_later
        render json: :confirmed
    end

    def upload_document
        payment = Payment.find_by_booking_id request.headers['x-booking-id'].to_i
        history = payment.payment_histories.new
        history.payment_mode_id = 1
        if history.save
            history.upload_document.attach(params[:files][0])
        end
        render json: :uploaded
    end

    def download_document
        booking = Booking.find_by_id params[:id]
        if booking.payment.present?
            if booking.payment.payment_histories.present?
                    history = booking.payment.payment_histories.last
                    url_file = url_for(booking.payment.payment_histories.last.upload_document)
                    render json: {file_data: url_file}
            end
        end
    end

    def export 
        @bookings = data_search
        AuditLog.log_changes("Bookings", "booking_export", "", "", get_log_text(), 2, @current_user.username)
    end

    def filter 
        @bookings = data_search.page(filter_params[:page])
    end

    def index
        @locations = Location.all
        @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ?",4)
    end

    def show
        @booking = Booking.find params[:id]
        @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ?",4)
        @payment_mode = PaymentMode.all
    end

    def cancel_booking
        booking = Booking.find(params[:id])
        update_status = booking.payment.update(payment_status: 4)
        slot = booking.slot.increment!(:allocations, 1)
        slot_status = booking.slot.update(status: true)

        AuditLog.log_changes("Bookings", "booking_cancel", booking.id, "", "", 1, @current_user.username)
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
        # booking.payment.update(payment_status: 0)

        #send reschedule email
        if !booking.payment.nil?
            if booking.payment.payment_status == "reserved"
                BookingMailer.reservation(params[:past_booking_details][:id]).deliver_later
            end
            if booking.payment.payment_status == "confirmed"
                BookingMailer.manual_confirmation(params[:past_booking_details][:id]).deliver_later
            end 
        end

        # Update old slod to be available
        old_slot = Slot.find params[:past_booking_details][:slot][:id]
        old_slot.increment!(:allocations, 1)
        old_slot.update(status: true)
        old_datetime = booking.schedule.schedule_date.strftime("%d %A %Y") + ", " + old_slot.slot_time.utc.strftime("%I:%M") + old_slot.meridian + " - " + (old_slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M") + old_slot.meridian

        # Update new slot, add allocation and modify status
        new_slot = Slot.find params[:new_booking_details][:slot][:id]
        new_slot.decrement!(:allocations, 1)
        if new_slot[:allocations] == 0
            new_slot.update(status: false)
        end
        new_datetime = booking.schedule.schedule_date.strftime("%d %A %Y") + ", " + new_slot.slot_time.utc.strftime("%I:%M") + new_slot.meridian + " - " + (new_slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M") + new_slot.meridian
        booking.update(slot_id: new_slot.id)

        AuditLog.log_changes("Bookings", "booking_schedule", booking.id, old_datetime, new_datetime, 1, @current_user.username)
       
        render json: {
            schedule: booking.schedule, 
            slot: booking.slot, 
            slot_time_with_interval: booking.slot.slot_time.utc.strftime("%I:%M") + booking.slot.meridian + " - " + (booking.slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M") + booking.slot.meridian,
            payment_status: booking.payment.payment_status}
    end


    private 
    def data_search
        Booking.search_filter(filter_params)
            .search(filter_params[:search_string])
    end
    def get_log_text
        header = "Exported CSV with filters "
        test_site = "test site: #{filter_params[:location_id] == 0? "All" : Location.find(filter_params[:location_id]).name}, "
        status = "status: #{Payment.payment_statuses.invert[filter_params[:status]]}, "
        search = "search: #{filter_params[:search_string] == nil ? "blank" : filter_params[:search_string]}, "
        registration_date = "registration date from #{filter_params[:register_date_start] == nil ? "blank" : filter_params[:register_date_start].to_date.strftime("%d %A %Y")} to #{filter_params[:register_date_end] == nil ? "blank" : filter_params[:register_date_end].to_date.strftime("%d %A %Y")}, "
        appointment_date = "appointment date from #{filter_params[:booking_date_start] == nil ? "blank" : filter_params[:booking_date_start].to_date.strftime("%d %A %Y")} to #{filter_params[:booking_date_end] == nil ? "blank" : filter_params[:booking_date_end].to_date.strftime("%d %A %Y")}, "
        booking_reserve = "booking reserved more than 60 minutes #{filter_params[:only_expired_booking] ? "Y" : "N"}"
        
        log_text = header + test_site + status + search + registration_date + appointment_date + booking_reserve
        log_text
    end
    def filter_params
        params
            .require(:filter)
            .permit(:location_id, :status, :booking_date_start, :booking_date_end, :page , :search_string, :only_expired_booking, :register_date_start, :register_date_end, :booking_type)
    end
    def manual_payment_params 
        params.require(:payment).permit(:booking_id, :payment_reference, :payment_date, :amount, :payment_mode, :type)
    end
end
