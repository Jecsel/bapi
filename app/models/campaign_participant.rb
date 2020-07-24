class CampaignParticipant < ApplicationRecord
  belongs_to :campaign
  belongs_to :participant

  scope :active, -> { where(:status => true)}
end
