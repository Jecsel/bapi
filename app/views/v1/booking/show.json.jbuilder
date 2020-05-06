json.booking_details do
    json.extract! @booking, :id, :reference_code
    json.payment_status @booking.payment.payment_status
    json.test_site_name @booking.location.name
    json.test_site_code @booking.location.code
    json.test_site_id @booking.location.id
    json.clinic_name @booking.clinic.name
    json.clinic_code @booking.clinic.code
    json.billing_code @booking.clinic.billing_code
    json.slot @booking.slot
    json.time_add @booking.slot.slot_time + (@booking.schedule.minute_interval*60)
    json.schedule @booking.schedule
    json.location @booking.location
end
json.patient_details do 
    json.extract! @booking.patient, :fullname, :id_number, :date_of_birth, :contact_number, :email_address
    json.gender @booking.patient.gender_id == 1? "Male": "Female"
end
json.question_details do
    json.q1 @booking.patient.q1 ? "Yes": "No"
    json.q2 @booking.patient.q2 ? "Yes": "No"
end