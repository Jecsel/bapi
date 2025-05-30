json.booking_details do
    json.extract! @booking, :id, :reference_code, :booking_type
    json.payment_status @booking.payment.payment_status
    json.test_site_name @booking.location.name
    json.test_site_code @booking.location.code
    json.test_site_id @booking.location.id
    json.clinic_name @booking.clinic.name
    json.clinic_code @booking.clinic.code
    json.billing_code @booking.clinic.billing_code
    json.slot_time_with_interval @booking.slot.slot_time_with_interval 
    json.slot @booking.slot
    json.schedule @booking.schedule
    json.location @booking.location
    json.payment_price @booking.payment.amount
end
json.patient_details do 
    json.extract! @booking.patient, :fullname, :id_number, :date_of_birth, :contact_number, :email_address, :line_1, :line_2, :post, :state_id, :state_name
    json.gender @booking.patient.gender_id == 1? "Male": "Female"
end
json.question_details do
    json.q1 @booking.patient.q1 ? "Yes": "No"
    json.q2 @booking.patient.q2 ? "Yes": "No"
end
json.payment_details do
    json.extract! @booking, :id, :reference_code
    json.payment_status @booking.payment.payment_status
    json.ref_no @booking.payment.payment_histories.any? ? @booking.payment.payment_histories.last.payment_reference : ""
    json.amount @booking.payment.amount
    json.amount_updated @booking.payment.payment_histories.any? ? @booking.payment.payment_histories.last.amount : ""
    json.currency @booking.payment.currency
    json.payment_date @booking.payment.payment_histories.any? ? @booking.payment.payment_histories.last.created_at : ""
    json.payment_mode @booking.payment.payment_histories.any? && !@booking.payment.payment_histories.last.payment_mode_id.nil? ? @booking.payment.payment_histories.last.payment_mode.name : ""
    json.payment_type @booking.payment.payment_type
    json.username @booking.payment.payment_histories.any? ? @booking.payment.payment_histories.last.approved_by : "N/A"
    json.updated_at @booking.payment.updated_at
    json.file_name @booking.payment.payment_histories.any? && !@booking.payment.payment_histories.last.upload_document.attachment.nil?  ? @booking.payment.payment_histories.last.upload_document.filename : "N/A"
end
json.controls @role_policy do |rol|
    json.extract! rol.service_policy, :id, :status
end
json.payment_modes @payment_mode, :id, :name