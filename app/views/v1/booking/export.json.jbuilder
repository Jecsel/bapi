json.array! @bookings do |booking|
    json.id booking.id
    json.registration_datetime booking.created_at.to_s(:long)
    json.reserved_duration time_ago_in_words(booking.created_at)
    json.booking_date booking.schedule.schedule_date
    json.booking_time booking.slot.slot_time.utc.strftime("%I:%M%p") +' - '+(booking.slot.slot_time + booking.schedule.minute_interval * 60).utc.strftime("%I:%M%p")
    json.payment_status booking.payment.payment_status
    json.booking_type booking.booking_type
    json.reference_number booking.reference_code
    json.fullname booking.patient.fullname
    json.id_number booking.patient.id_number
    json.date_of_birth booking.patient.date_of_birth
    json.gender booking.patient.gender_id == 1? "M": "F"
    json.contact_number booking.patient.contact_number
    json.email_address booking.patient.email_address
    json.q1 booking.patient.q1 ? "Y": "N"
    json.q2 booking.patient.q2 ? "Y": "N"
    json.test_site booking.location.name unless booking.location.nil?
    json.test_site_code booking.location.code unless booking.location.nil?
    json.clinic_name booking.clinic.name unless booking.clinic.nil?
    json.clinic_code booking.clinic.code unless booking.clinic.nil?
    json.clinic_email_address booking.clinic.email_address unless booking.clinic.nil?
    json.clinic_contact_person booking.clinic.contact_person unless booking.clinic.nil?
    json.billing_code booking.clinic.billing_code unless booking.clinic.nil?
    json.payment_date booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.created_at : ""
    json.payment booking.payment.payment_type
    json.payment_mode booking.payment.payment_type == "auto" ? "iPay88" : booking.payment.payment_histories.any? && !booking.payment.payment_histories.last.payment_mode_id.nil? ? booking.payment.payment_histories.last.payment_mode.name : ""
    json.ref_no booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.payment_reference : "N/A"
    json.amount booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.amount : ""
    json.currency booking.payment.currency
    json.file_name booking.payment.payment_histories.any? && !booking.payment.payment_histories.last.upload_document.attachment.nil? ? booking.payment.payment_histories.last.upload_document.filename.to_s : "N/A" if booking.payment.payment_histories.any?
    json.username booking.payment.payment_histories.any? ? booking.payment.payment_histories.last.approved_by : "N/A"
    json.updated_at booking.payment.updated_at
    json.line_1 booking.patient.line_1
    json.line_2 booking.patient.line_2
    json.post booking.patient.post
    json.state_id booking.patient.state_id
    json.state_name booking.patient.state_name
end




