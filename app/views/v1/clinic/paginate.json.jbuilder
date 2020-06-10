p @clinics_page
json.clinic_list @clinics_page do |clinic|
    p clinic
    json.extract! clinic, :id , :name, :code, :email_address, :contact_number, :contact_person, :address, :billing_code, :status
    json.clinic_area_name clinic.clinic_area.name unless clinic.clinic_area.nil?
end
json.counts @clinics_page.count
json.total_pages @clinics_page.total_pages
json.total_count @clinics_page.total_count




