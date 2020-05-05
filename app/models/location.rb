class Location < ApplicationRecord
    has_many :schedules
    has_many :location_clinics
    has_many :clinics, through: :location_clinics

    scope :active, -> { where(:status => true)}
end
