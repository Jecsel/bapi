class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        clinic_copy = @booking.clinic.present? ? @booking.clinic.email_address.split() : []
        mail(
            to: @booking.payment.user_email, 
            cc: ENV["CC_MAIL"].split("|"),
            bcc: clinic_copy,
            subject: "COVID-19 Drive-Through Booking Confirmation  | REF: #{@booking.reference_code}")
    end
    # 
end