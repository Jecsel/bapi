class Booking < ApplicationRecord
    include SearchCop

    before_create :generate_ref_code
    has_one :payment
    belongs_to :patient
    belongs_to :location
    belongs_to :slot
    belongs_to :clinic
    belongs_to :schedule
    belongs_to :clinic
    private

    search_scope :search do
        attributes :id, :reference_code
        attributes patient: ["patient.id_number", "patient.fullname"]
    end

    def self.search_filter( filter_params )
        _sql =  get_location(filter_params[:location_id]).payment_status(filter_params[:status])
                
        if filter_params[:booking_date_start].present? && filter_params[:booking_date_end].present?
            return _sql.where(schedules:{schedule_date:[filter_params[:booking_date_start]..filter_params[:booking_date_end]]})
        end
        if filter_params[:booking_date_start].present? && filter_params[:booking_date_end].nil?
            return _sql.where("schedules.schedule_date >= ?",filter_params[:booking_date_start])
        end
        if filter_params[:booking_date_start].nil? && filter_params[:booking_date_end].present?
            return _sql.where("schedules.schedule_date <= ?",filter_params[:booking_date_end]) 
        end
        return _sql
    end
    
    def self.get_location id 
        return where(location_id: id) if id != 0
        return self
    end
    def self.payment_status status
        return where({payments:{payment_status:status}})
    end
    

    def generate_ref_code
        self.reference_code = Generator.new().generate_reference_code
    end

    def self.get_status status_index
        joins(:payment).where("payments.payment_status = ?",status_index)
    end

    def self.get_site location_id
        self.where(location_id: location_id)
    end
end
