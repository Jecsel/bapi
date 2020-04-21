class V1::Booking::LocationController < ApplicationController
    
    def index
        @locations = Location.all
    end

end
