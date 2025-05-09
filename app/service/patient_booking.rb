    class PatientBooking
    attr_accessor   :location_id,
                    :slot_id,
                    :schedule_id,
                    :patient,
                    :covid_price,
                    :referral_code,
                    :payment
                    :slot

    def initialize booking_params
        @covid_price    = Setting.last.covid_price
        @location_id    = booking_params[:location][:id]
        @slot_id        = booking_params[:slot][:id]
        @schedule_id    = booking_params[:schedule][:id] 
        @patient        = booking_params[:patient]
        @referral_code  = booking_params[:referral_code]
        validate_request

        generate_patient_record
    end

    private 
    def validate_request
        @slot = Slot.find slot_id
        # if @slot.allocations == 0 || @slot.status == false
        #     raise "Slot is no longer available"
        # end
    end
    def generate_patient_record
        ActiveRecord::Base.transaction do
            _allocations = @slot.allocations
            if _allocations > 1
                @slot.update allocations: _allocations - 1
            else
                @slot.update allocations: 0,status:false
            end
            _patient = Patient.create({ 
                fullname: patient[:full_name],
                id_number: patient[:id_number],
                gender_id: patient[:gender_id],
                date_of_birth: patient[:date_of_birth],
                contact_number: patient[:contact_number],
                email_address: patient[:email_address],
                q1: patient[:q1],
                q2: patient[:q2],
                line_1: patient[:line_1],
                line_2: patient[:line_2],
                post: patient[:post],
                state_id: patient[:state_id],
                state_name: patient[:state_name]
            })
            generate_guest_booking _patient
        end
    end
    
    def generate_guest_booking _patient
        booking = _patient.bookings.create({
            location_id: location_id,
            slot_id: slot_id,
            schedule_id: schedule_id,
            clinic_id: patient[:clinic_id],
            amount: covid_price,
            referral_code: referral_code,
            booking_type: patient[:booking_type] ? 1 : 0
        })
        generate_payment_info booking
    end

    def generate_payment_info booking
        filename = "pre_payment_#{Time.now.to_i}"
        pay = booking.build_payment
        pay.patient_id = booking.id
        pay.merchant_code = ENV["MERCHANT_CODE"]
        pay.payment_id= 2
        pay.payment_status = 0
        pay.ref_no = booking.reference_code
        pay.amount = covid_price
        pay.currency = "MYR"
        pay.prod_desc = "Payment for COVID-19 Testing"
        pay.username = booking.patient.fullname
        pay.user_email = booking.patient.email_address
        pay.user_contact = booking.patient.contact_number
        pay.remark = "Payment"
        pay.lang = "ISO-8859-1"
        pay.signature_type = "SHA256"
        pay.signature = calculate_hash_key pay
        pay.s3_artifact = filename
        pay.save
        @payment = pay
        pay.update s3_artifact:filename
        _s3 = S3Bucket.new 
        _s3.upload @payment.to_json, filename
    end

    def calculate_hash_key pay
        __code = "#{ENV["MERCHANT_KEY"]}#{ENV["MERCHANT_CODE"]}#{pay.ref_no}#{pay.amount.gsub('.', "")}#{pay.currency}"
        return Digest::SHA256.hexdigest __code
    end

end