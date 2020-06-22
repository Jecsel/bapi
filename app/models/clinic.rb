class Clinic < ApplicationRecord
    include SearchCop
    scope :active, ->{where(status:true)}
    belongs_to :clinic_area

    search_scope :search do
        attributes :code, :name, :address
    end
end
