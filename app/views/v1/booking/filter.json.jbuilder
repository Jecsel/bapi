json.bookings @bookings do |booking|
    json.extract! booking, :id, :reference_code, :created_at, :booking_type
    json.location_name booking.location.name unless booking.location.nil?
    json.slot_time_with_interval booking.slot.slot_time_with_interval
    json.date booking.schedule.schedule_date
    json.name booking.patient.fullname
    json.payment_status booking.payment.payment_status
    json.id_number booking.patient.id_number
    json.reserved_duration time_ago_in_words(booking.created_at) 
    json.is_time_exceed_60 Time.now > booking.created_at +  60.minutes
end
json.counts @bookings.count
json.total_pages @bookings.total_pages
json.total_count @bookings.total_count
