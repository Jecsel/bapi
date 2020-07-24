json.campaign_participants @campaign_participants.each do |part|
    json.extract! part, :id, :fullname, :date_of_birth, :gender, :id_number, :mobile, :email, :staff_id, :department, :barcode
end