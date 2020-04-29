json.bookings @bookings do |booking|
    json.extract! booking, :id, :reference_code
    json.location_name booking.location.name
    json.time booking.slot.slot_time
    json.date booking.schedule.schedule_date
    json.name booking.patient.fullname
    json.payment_status booking.payment.payment_status
    json.id_number booking.patient.id_number
end
json.csv_export_data @bookings do |booking|
    json.id booking.id
    json.booking_date booking.schedule.schedule_date
    json.booking_time booking.slot.slot_time.utc.strftime("%I:%M%p")
    json.reference_number booking.reference_code
    json.fullname booking.patient.fullname
    json.id_number booking.patient.id_number
    json.date_of_birth booking.patient.date_of_birth
    json.gender booking.patient.gender_id == 1? "M": "F"
    json.contact_numberg booking.patient.contact_number
    json.email_address booking.patient.email_address
    json.q1 booking.patient.q1 ? "Y": "N"
    json.q2 booking.patient.q2 ? "Y": "N"
    json.test_site booking.location.name
    json.clinic_name booking.clinic.name
    json.clinic_code booking.clinic.code
    json.price Setting.last.covid_price
    json.payment_date booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.created_at : "N/A"
    json.payment_status booking.payment.payment_status
end
json.counts @bookings.count
json.total_pages @bookings.total_pages
json.total_count @bookings.total_count