class V1::Guest::BookingController < ApplicationController
    
    def create
        begin
            data = PatientBooking.new booking_params    
            # SlotWorker.perform_in(1.hour, data.payment.booking_id )
            # BookingMailer.itinerary(data.payment.booking_id).deliver_later
            BookingMailer.reservation(data.payment.booking_id).deliver_later
            render json: {
                status:true, 
                data:data.payment,
                response_url:ENV["MERCHANT_RESPONSE_URL"],
                backend_url:ENV["MERCHANT_BACKEND_URL"]
            }
        rescue => ex
            render json: {message:ex,status:false},status:403
        end
    end

    
    private
    def later_params
        params.require(:later).permit(:id)
    end

    def booking_params
        params
            .require(:booking)
            .permit(
                :referral_code,
                :location=>[:id],
                :slot=>[:id],
                :schedule=>[:id],
                :patient=>[
                    :full_name,
                    :id_number,
                    :gender_id,
                    :date_of_birth,
                    :contact_number,
                    :email_address,
                    :q1,
                    :q2,
                    :clinic_id,
                    :booking_type
                ]
            )
    end
end
