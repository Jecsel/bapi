class V1::DashboardController < ApplicationController
    before_action :must_be_authenticated

    def booking_graph
        #enum payment_status:[:reserved, :confirmed, :missed, :completed, :cancelled, :reschedule]

        bookings = Booking.all.group_by(&:schedule_id)
        data = []
        bookings.each do |e|
            status  = Payment.where(id:e.last.pluck(:id)).group(:payment_status).count
            data << {
                booking_date: e.last.first.schedule.schedule_date,
                reserved: status["reserved"] || 0,
                confirmed: status["confirmed"] || 0,
                missed: status["missed"] || 0,
                completed: status["completed"] || 0,
                cancelled: status["cancelled"] || 0,
                reschedule: status["reschedule"] || 0,
            }
        end
        render json: data
    end
end
