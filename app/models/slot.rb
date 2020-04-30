class Slot < ApplicationRecord
    scope :available, ->{where(status:true)}
end
