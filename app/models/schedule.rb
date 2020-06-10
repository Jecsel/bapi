class Schedule < ApplicationRecord
    has_many :slots
    has_many :bookings
    scope :available, ->{where(status:true)}
    def has_available_slot
        self.slots.available.any?
    end
end
