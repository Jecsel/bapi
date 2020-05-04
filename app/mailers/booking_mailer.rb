class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        # attachments['itinerary.pdf'] = File.read("#{Rails.root}/tmp/itinerary.pdf")
        mail(
            to: @booking.payment.user_email, 
            cc: ["ramel.cabug-os@biomarking.com"],
            subject: "COVID-19 Drive-Through Booking Confirmation  | REF: #{@booking.reference_code}")
    end
end