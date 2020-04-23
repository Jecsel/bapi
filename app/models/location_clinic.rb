class LocationClinic < ApplicationRecord
  belongs_to :clinic
  belongs_to :location
end
