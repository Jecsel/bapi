class V1::Guest::BookingController < ApplicationController
    
    def payment_confirmation
        @data = params
    end
    def create
        begin
            data = PatientBooking.new booking_params    
            render json: {status:true, data:data.payment}
            sleep 2
        rescue => ex
            render json: {message:ex,status:false},status:403
        end
    end
    
    private
    def booking_params
        params
            .require(:booking)
            .permit(
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
                ]
            )
    end
end
