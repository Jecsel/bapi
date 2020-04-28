class Patient < ApplicationRecord
    has_many :bookings
    enum gender_id:["Male","Female"]
end
