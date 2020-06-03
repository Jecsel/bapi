class Schedule < ApplicationRecord
    has_many :slots

    def has_available_slot
        self.slots.available.any?
    end
end
