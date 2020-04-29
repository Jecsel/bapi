json.bookings @bookings do |booking|
    json.extract! booking, :id, :reference_code
    json.location_name booking.location.name
    json.time booking.slot.slot_time
    json.date booking.schedule.schedule_date
    json.name booking.patient.fullname
    json.payment_status booking.payment.payment_status
    json.id_number booking.patient.id_number
end
json.location_list @locations.each do |location|
    json.extract! location, :id, :name
end
json.controls @role_policy do |rol|
    json.extract! rol.service_policy, :id, :status
end
json.counts @bookings.count
json.total_pages @bookings.total_pages
json.total_count @bookings.total_count