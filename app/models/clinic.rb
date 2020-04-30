class Clinic < ApplicationRecord

    scope :active, ->{where(status:true)}
end
