class Booking < ApplicationRecord
    include SearchCop

    before_create :generate_ref_code
    has_one :payment
    belongs_to :patient
    belongs_to :location
    belongs_to :slot
    belongs_to :schedule
    private

    search_scope :search do
        attributes :id, :reference_code
        attributes schedule: ["schedule.schedule_date"]
        attributes patient: ["patient.id_number", "patient.fullname"]
        attributes slot: ["slot.slot_time"]
        attributes location: ["location.name"]
	end
    
    def generate_ref_code
        self.reference_code = Generator.new().generate_reference_code
    end

    def self.get_status status_index
        joins(:payment).where("payments.payment_status = ?",status_index)
      end
end
