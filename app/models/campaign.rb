class Campaign < ApplicationRecord
  has_one_attached :upload_document
  
  belongs_to :campaign_client
  belongs_to :campaign_company
  belongs_to :campaign_billing
  belongs_to :campaign_doctor

  has_many :campaign_participants

  enum in_charge:["Dummy1", "Dummy2", "Dummy3"]
end
