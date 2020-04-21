json.array! @bookings do |booking|
    json.extract! booking, :patient_id, :reference_code, :amount, :created_at
    json.location_name booking.location.name
    json.time booking.slot.slot_time
    json.date booking.schedule.schedule_date
    json.name booking.patient.fullname
end