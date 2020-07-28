json.campaigns @campaign.each do |camp|
    json.extract! camp, :id, :event_name, :campaign_start_date, :campaign_end_date, :package, :optional_test, :est_pax, :no_of_phleb, :onsite_pic_contact, :status
    json.campaign_start_time camp.campaign_start_time.strftime("%I:%M %p")
    json.campaign_end_time camp.campaign_end_time
    json.in_charge camp.in_charge_person.name
    json.client_name camp.campaign_client.name
    json.doctor_code camp.campaign_doctor.code
end
json.counts @campaign.count
json.total_pages @campaign.total_pages