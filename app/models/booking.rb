class Booking < ApplicationRecord
    before_create :generate_ref_code
    has_one :payment
    belongs_to :patient
    private
    
    def generate_ref_code
        self.reference_code = Generator.new().generate_reference_code
    end
end
