class ClinicArea < ApplicationRecord
    scope :active, ->{where(status:true)}
end
