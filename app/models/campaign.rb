class Campaign < ApplicationRecord
  belongs_to :campaign_client
  belongs_to :campaign_company
  belongs_to :campaign_billing
  belongs_to :campaign_doctor


  enum in_charge:["Dummy1", "Dummy2", "Dummy3"]
end
