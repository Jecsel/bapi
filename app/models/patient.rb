class Patient < ApplicationRecord
    has_many :bookings
    # enum gender_id:["Unknown","Male","Female"]
end
