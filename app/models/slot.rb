class Slot < ApplicationRecord
    
    has_many :bookings
    belongs_to :schedule
    
    scope :available, ->{where(status:true)}
    scope :booked, ->{where(status:false)}

    def self.active 
        where("is_deleted = ?",false)
    end
    def slot_time_with_interval
        self.slot_time.utc.strftime("%I:%M %p")+ " - " + (self.slot_time + self.schedule.minute_interval*60).utc.strftime("%I:%M %p")
    end

    def self.count_total_available_slots 
        where(status:true).sum(&:allocations)
    end

    def self.count_total_available_slots_not_deleted
        where(is_deleted:false).sum(&:allocations)
    end
end
