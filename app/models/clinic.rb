class Clinic < ApplicationRecord
    scope :active, ->{where(status:true)}
    belongs_to :clinic_area
end
