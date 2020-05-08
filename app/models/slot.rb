class Slot < ApplicationRecord
    
    has_many :bookings
    
    scope :available, ->{where(status:true)}

    def full_duration
        self.slot_time + 10.minutes
    end
end
