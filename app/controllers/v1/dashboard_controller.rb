class V1::DashboardController < ApplicationController
    before_action :must_be_authenticated

    def booking_graph
        today = DateTime.now.in_time_zone
        bookings = Booking.all.order(:id).group_by(&:schedule_id)
        
        clinics = Clinic.count
        users = User.count
        locations = Location.count
        today_bookings = Booking.joins(:schedule).where("bookings.created_at >= ?",today.beginning_of_day).count
        graph_data = []
        bookings.each do |e|
            status  = Payment.where(booking_id:e.last.pluck(:id)).group(:payment_status).count
            graph_data << {
                booking_date: e.last.first.schedule.created_at.strftime("%^b %e"),
                reserved: status["reserved"] || 0,
                confirmed: status["confirmed"] || 0,
                missed: status["missed"] || 0,
                completed: status["completed"] || 0,
                cancelled: status["cancelled"] || 0,
                reschedule: status["reschedule"] || 0,
            }
        end
        render json: {
            users: users,
            locations: locations,
            clinics: clinics,
            todays_bookings: today_bookings,
            graph_data: graph_data
        }
    end
end
