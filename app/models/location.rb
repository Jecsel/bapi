class Location < ApplicationRecord
    include SearchCop

    has_many :schedules
    has_many :location_clinics
    has_many :clinics, through: :location_clinics

    enum referral_type: [:Clinic,:Hospital]

    search_scope :search do
        attributes :id, :name, :address, :code
    end

    def self.get_status status_id
        where(status: status_id)
    end

    def self.get_referral referral
        where(referral_type: referral)
    end

    scope :active, -> { where(:status => true)}
    scope :inactive, -> { where(:status => true)}
end
