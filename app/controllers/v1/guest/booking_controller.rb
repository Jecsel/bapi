class V1::Guest::BookingController < ApplicationController
    
    def create
        render json: booking_params    
    end
    
    private
    def booking_params
        params
            .require(:booking)
            .permit(
                :location=>[:id],
                :slot=>[:id],
                :schedule_date=>[:id],
                :patient=>[
                    :fullname,
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
