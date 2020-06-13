class Location < ApplicationRecord
    include SearchCop

    has_many :schedules
    has_many :location_clinics
    has_many :clinics, through: :location_clinics

    enum referral_type: [:Clinic,:Hospital]

    search_scope :search do
        attributes :id, :name, :address, :code
    end

    def self.search_filter filter_params
        _sql = self.where("status = ?",filter_params[:status])
        if filter_params[:referral] != "all"
            _sql = _sql.where("referral_type = ?",filter_params[:referral])
        end
        
        if filter_params[:search_str].present?
            _sql = _sql.search(filter_params[:search_str])
        end
        return _sql
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
