class Booking < ApplicationRecord
    before_create :generate_ref_code
    has_one :payment
    belongs_to :patient
    belongs_to :location
    belongs_to :slot
    belongs_to :clinic
    belongs_to :schedule
    private
    
    def generate_ref_code
        self.reference_code = Generator.new().generate_reference_code
    end
end
