class V1::BookingController < ApplicationController
    
    def index
        @bookings = Booking.all
    end
end
