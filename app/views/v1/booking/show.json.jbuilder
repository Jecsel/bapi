json.booking_details do
    json.extract! @booking, :id, :reference_code
    json.booking_date @booking.schedule.schedule_date
    json.slot_time @booking.slot.slot_time
    json.payment_status @booking.payment.payment_status
    json.test_site_name @booking.location.name
    json.test_site_id @booking.location.id
    json.clinic_name @booking.clinic.name
    json.clinic_code @booking.clinic.code
end
json.patient_details do 
    json.extract! @booking.patient, :fullname, :id_number, :date_of_birth, :contact_number, :email_address
    json.gender @booking.patient.gender_id == 1? "Male": "Female"
end
json.question_details do
    json.q1 @booking.patient.q1 ? "Yes": "No"
    json.q2 @booking.patient.q2 ? "Yes": "No"
end