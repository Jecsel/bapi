json.clinic_list @clinics do |clinic|
    json.extract! clinic, :id , :name, :code, :email_address, :contact_number, :contact_person, :address, :billing_code, :status
    json.clinic_area_name clinic.clinic_area.name unless clinic.clinic_area.nil?
end
json.total_pages @clinics.total_pages
json.total_count @clinics.total_count