json.campaigns @campaign.each do |camp|
    json.extract! camp, :id, :event_name, :campaign_start_date, :campaign_end_date, :campaign_start_time, :campaign_end_time, :package_code, :optional_test, :est_pax, :no_of_phleb, :onsite_pic_contact, :in_charge, :status
    json.client_name camp.client.name
    json.doctor_code camp.doctor.code
end