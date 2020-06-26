class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        if @booking.clinic.present? 
            _bcc << @booking.clinic.email_address
        end
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end
    def reservation booking_id
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        if @booking.clinic.present? 
            _bcc << @booking.clinic.email_address
        end
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Reservation | REF: #{@booking.reference_code}")
    end
    
    def manual_confirmation booking_id
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        if @booking.clinic.present? 
            _bcc << @booking.clinic.email_address
        end
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end
end