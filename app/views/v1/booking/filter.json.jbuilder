json.bookings @bookings do |booking|
    json.extract! booking, :id, :reference_code, :created_at
    json.location_name booking.location.name
    json.slot_time_with_interval booking.slot.slot_time.utc.strftime("%I:%M") + booking.slot.meridian + " - " + (booking.slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M") + booking.slot.meridian
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
