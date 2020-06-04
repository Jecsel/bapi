json.array! @bookings do |booking|
    json.id booking.id
    json.booking_date booking.schedule.schedule_date
    json.booking_time booking.slot.slot_time.utc.strftime("%I:%M%p") +' - '+(booking.slot.slot_time + booking.schedule.minute_interval * 60).utc.strftime("%I:%M%p")
    json.reference_number booking.reference_code
    json.fullname booking.patient.fullname
    json.id_number booking.patient.id_number
    json.date_of_birth booking.patient.date_of_birth
    json.gender booking.patient.gender_id == 1? "M": "F"
    json.contact_number booking.patient.contact_number
    json.email_address booking.patient.email_address
    json.q1 booking.patient.q1 ? "Y": "N"
    json.q2 booking.patient.q2 ? "Y": "N"
    json.test_site booking.location.name
    json.test_site_code booking.location.code
    json.clinic_name booking.clinic.name
    json.clinic_code booking.clinic.code
    json.billing_code booking.clinic.billing_code
    json.price Setting.last.covid_price
    json.payment_date booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.created_at : "N/A"
    json.payment_status booking.payment.payment_status
    json.payment booking.payment.payment_type ? "Auto": "Manual"
    json.payment_mode booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.payment_mode.name : ""
    json.ref_no booking.payment.ref_no
    json.amount booking.payment.amount
    json.currency booking.payment.currency
    json.file_name booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.upload_document.name : "N/A"
    json.username @current_user.username
    json.updated_at booking.payment.updated_at
end


