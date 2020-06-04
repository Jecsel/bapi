class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        clinic_copy = @booking.clinic.present? && !@booking.clinic.email_address.nil? ? @booking.clinic.email_address.split() : []
        mail(
            to: @booking.payment.user_email, 
            cc: ENV["CC_MAIL"].split("|"),
            bcc: clinic_copy,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end
    def pay_later_email booking_id
        @booking = Booking.find booking_id
        clinic_copy = @booking.clinic.present? && !@booking.clinic.email_address.nil?  ? @booking.clinic.email_address.split() : []
        mail(
            to: @booking.payment.user_email, 
            cc: ENV["CC_MAIL"].split("|"),
            bcc: clinic_copy,
            subject: "COVID-19 Drive-Thru Reservation | REF: #{@booking.reference_code}")
    end
    
    def manual_confirmation booking_id
        @booking = Booking.find booking_id
        clinic_copy = @booking.clinic.present? && !@booking.clinic.email_address.nil? ? @booking.clinic.email_address.split() : []
        mail(
            to: @booking.payment.user_email, 
            cc: ENV["CC_MAIL"].split("|"),
            bcc: clinic_copy,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end
end