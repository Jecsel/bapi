class CampaignParticipant < ApplicationRecord
  belongs_to :campaign
  belongs_to :participant
end
