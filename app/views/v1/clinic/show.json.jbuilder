json.clinic do
    json.extract! @clinics, :id, :name, :code, :email_address, :contact_number, :address, :contact_person, :billing_code, :clinic_area_id
    json.status_id @clinics.status ? "1" : "0"
    json.status_text @clinics.status ? "Active": "Inactive"
end
json.controls @role_policy do |rol|
    json.extract! rol.service_policy, :id, :status
end