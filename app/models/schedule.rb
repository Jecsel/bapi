class Schedule < ApplicationRecord
    has_many :slots
    has_many :bookings
    def has_available_slot
        self.slots.available.any?
    end
end
