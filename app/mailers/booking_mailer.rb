class BookingMailer < ApplicationMailer
    def itinerary booking
        @booking = booking
        # attachments['itinerary.pdf'] = File.read("#{Rails.root}/tmp/itinerary.pdf")
        mail(to: @booking.user_email, subject: "Booking Confirmation")
    end
end
