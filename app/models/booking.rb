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
    
  
    enum booking_type:[:patient, :clinic]

    search_scope :search do
        attributes :id, :reference_code
        attributes patient: ["patient.id_number", "patient.fullname"]
    end

    def self.filter_by_registration_date filter_params
        if filter_params[:register_date_start].present? && filter_params[:register_date_end].present?
            _start = filter_params[:register_date_start].to_date.beginning_of_day
            _end = filter_params[:register_date_end].to_date.end_of_day
            return where(bookings:{created_at:[_start.._end]})
        end
        if filter_params[:register_date_start].present? && filter_params[:register_date_end].nil?
            _start = filter_params[:register_date_start].to_date.beginning_of_day
            return where("bookings.created_at >= ?",_start)
        end
        if filter_params[:register_date_start].nil? && filter_params[:register_date_end].present?
            _end = filter_params[:register_date_end].to_date.end_of_day
            return where("bookings.created_at <= ?",_end) 
        end
    end

    def self.search_filter( filter_params )
        _sql =  joins(:payment , :slot, :schedule)
        if filter_params[:location_id] != 0
            _sql = _sql.where(location_id: filter_params[:location_id])
        end
        if filter_params[:location_id] != 0
            _sql = _sql.where(location_id: filter_params[:location_id]) 
        end
        if filter_params[:status] != 32767
            _sql = _sql.payment_status(filter_params[:status])
        end
        if filter_params[:booking_type] != "all"
            _sql = _sql.where("bookings.booking_type = ?",filter_params[:booking_type])
        end
        if filter_params[:register_date_start].present? || filter_params[:register_date_end].present?
            _sql = _sql.filter_by_registration_date filter_params
        end 
        if filter_params[:only_expired_booking]
            elapse_time = Time.now - 60.minutes
            _sql = _sql.where("bookings.created_at <= ?",elapse_time)
        end
        if filter_params[:booking_date_start].present? && filter_params[:booking_date_end].present?
            _sql = _sql.where(schedules:{schedule_date:[filter_params[:booking_date_start]..filter_params[:booking_date_end]]})
        end
        if filter_params[:booking_date_start].present? && filter_params[:booking_date_end].nil?
            _sql = _sql.where("schedules.schedule_date >= ?",filter_params[:booking_date_start])
        end
        if filter_params[:booking_date_start].nil? && filter_params[:booking_date_end].present?
            _sql =_sql.where("schedules.schedule_date <= ?",filter_params[:booking_date_end]) 
        end
        _sql = _sql.order("schedules.schedule_date ASC, slots.slot_time ASC")
        return _sql
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

    def self.sort_by_datetime
        self.joins(:schedule).order(schedule_date: :asc)
    end
end
