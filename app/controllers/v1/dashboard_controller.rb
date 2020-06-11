class V1::DashboardController < ApplicationController
    before_action :must_be_authenticated

    def booking_graph
        clinics = Clinic.count
        users = User.count
        locations = Location.count

        today = DateTime.now.in_time_zone.to_date
        seven_day_ago = today - 7.days
        today_bookings = Booking.joins(:schedule).where("bookings.created_at >= ?",today.beginning_of_day).count

        graph_data = []

        (seven_day_ago..today).to_a.each do |date|
            status = Booking.joins(:payment).where(bookings:{created_at:[date.beginning_of_day..date.end_of_day]}).group("payments.payment_status").count
            graph_data << {
                booking_date: date.strftime("%^b %e"),
                reserved: status[0] || 0,
                confirmed: status[1] || 0,
                missed: status[2] || 0,
                completed: status[3] || 0,
                cancelled: status[4] || 0,
                reschedule: status[5] || 0,
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
