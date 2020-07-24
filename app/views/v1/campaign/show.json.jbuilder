json.campaigns_data do
    json.extract! @campaign, :id, :event_name, :campaign_site, :campaign_start_date, :campaign_end_date, :campaign_start_time,
        :campaign_end_time, :package, :optional_test, :est_pax, :no_of_phleb, :onsite_pic_contact, :in_charge,
        :need_phleb, :remarks, :report_management, :onsite_pic_name, :created_at, :updated_at, :created_by, :updated_by
    json.campaign_doctor @campaign.campaign_doctor.code
    json.campaign_billing @campaign.campaign_billing.name
    json.campaign_company @campaign.campaign_company.name
    json.campaign_client @campaign.campaign_client.name
    json.status @campaign.status ? 1 : 0
    json.optional_test @campaign.optional_test ? "Yes" : 'No'
end
json.campaign_participants @campaign_participants.each do |part|
    json.extract! part.participant, :id, :fullname, :date_of_birth, :gender, :id_number, :mobile, :email, :staff_id, :department, :barcode
end
json.campaign_participants_count @campaign_participants.total_count
json.campaign_participants_pages @campaign_participants.total_pages