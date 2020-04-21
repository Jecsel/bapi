json.array! @location_clinics do |lc|
    json.clinic_id lc.clinic.id
    json.clinic_name lc.clinic.name
 end