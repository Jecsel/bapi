class Slot < ApplicationRecord
    
    has_many :bookings
    
    scope :available, ->{where(status:true)}
end
