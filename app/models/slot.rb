class Slot < ApplicationRecord
    
    has_many :bookings
    belongs_to :schedule
    
    scope :available, ->{where(status:true)}

    def slot_time_with_interval
        self.slot_time.utc.strftime("%I:%M%p") + " - " + (self.slot_time + self.schedule.minute_interval*60).utc.strftime("%I:%M%p")
    end
end
