json.campaign_participants @campaign_participants.active.each do |part|
    json.extract! part.participant, :id, :fullname, :date_of_birth, :gender, :id_number, :mobile, :email, :staff_id, :department, :barcode
end