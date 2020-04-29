class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        # attachments['itinerary.pdf'] = File.read("#{Rails.root}/tmp/itinerary.pdf")
        mail(
            to: @booking.payment.user_email, 
            bcc: "ramel.cabug-os@biomarking.com",
            subject: "Booking Confirmation")
    end
end