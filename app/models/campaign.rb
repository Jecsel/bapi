class Campaign < ApplicationRecord
  belongs_to :campaign_client
  belongs_to :campaign_company
  belongs_to :campaign_billing
  belongs_to :campaign_doctor


  enum in_charge:["KAM", "MLO"]
end
