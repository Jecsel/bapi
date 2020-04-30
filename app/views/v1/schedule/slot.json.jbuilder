json.extract! @_slot, :id, :status, :slot_time, :allocations
json.bookings @_bookings do |book|
    json.extract! book, :reference_code    
    json.patient_name book.patient.fullname
    json.clinic book.clinic.name
    json.location book.location.name
end
# json.schedules @schedules, :id, :schedule_date