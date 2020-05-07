json.bookings @bookings do |booking|
    json.extract! booking, :id, :reference_code
    json.location_name booking.location.name
    json.time booking.slot.slot_time.utc.strftime("%I:%M%p") + " - " + (booking.slot.slot_time + booking.schedule.minute_interval*60).utc.strftime("%I:%M%p")
    json.date booking.schedule.schedule_date
    json.name booking.patient.fullname
    json.payment_status booking.payment.payment_status
    json.id_number booking.patient.id_number
end
json.counts @bookings.count
json.total_pages @bookings.total_pages
json.total_count @bookings.total_count
