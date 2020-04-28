class V1::BookingController < ApplicationController
    before_action :must_be_authenticated
    
    def index
        #Default get confirmed filter, get first page, get current datetime as search_start_date
        p DateTime.now
        @bookings = Booking.joins(:schedule).where("schedules.schedule_date >= ?", DateTime.now).joins(:slot).where("slots.slot_time >= ?", DateTime.now.strftime("%I:%M%p")).get_status(1).page(1) 
        @role_policy = @current_user.user_role.user_group.role_policies.where("role_policies.service_id = ?",4)
    end

    def paginate
        if params[:search_start_date] && params[:search_end_date]
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date >= ?" ,params[:search_end_date].to_datetime.beginning_of_day..params[:search_start_date].to_datetime.beginning_of_day)
            .joins(:slot).where("slots.slot_time >= ?", params[:search_start_date].strftime("%I:%M%p")..params[:search_end_date].strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(params[:page])
        elsif params[:search_start_date]
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date >= ?" ,params[:search_start_date].to_datetime.beginning_of_day)
            .joins(:slot).where("slots.slot_time >= ?",params[:search_start_date].to_datetime.strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(params[:page])
        elsif params[:search_end_date]
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date <= ?" ,params[:search_end_date].to_datetime.beginning_of_day)
            .joins(:slot).where("slots.slot_time <= ?",params[:search_end_date].to_datetime.strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(params[:page]) 
        else
            @bookings = Booking.search(params[:query])
            .search(params[:query])
            .get_status(params[:status_index])
            .page(params[:page])
        end 
    end

    def filter_booking
        if params[:search_start_date] && params[:search_end_date]
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date >= ?" ,params[:search_end_date].to_datetime..params[:search_start_date].to_datetime.beginning_of_day)
            .joins(:slot).where("slots.slot_time >= ?", params[:search_start_date].strftime("%I:%M%p")..params[:search_end_date].strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(1) 
        elsif params[:search_start_date]
            p params[:search_start_date]
            p 'wow'
            p params[:search_start_date].to_datetime
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date >= ?" ,params[:search_start_date].to_datetime)
            .joins(:slot).where("slots.slot_time >= ?",params[:search_start_date].to_datetime.strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(1) 

            @bookings = Booking.joins(:schedule).search(params[:query]).where("schedules.schedule_date >= ?" ,params[:search_start_date].to_datetime.beginning_of_day).joins(:slot).where("slots.slot_time >= ?",params[:search_start_date].to_datetime.strftime("%I:%M%p")).get_status(params[:status_index]).page(1) 
        elsif params[:search_end_date]
            @bookings = Booking.joins(:schedule)
            .search(params[:query])
            .where("schedules.schedule_date <= ?" ,params[:search_end_date].to_datetime)
            .joins(:slot).where("slots.slot_time <= ?",params[:search_end_date].to_datetime.strftime("%I:%M%p"))
            .get_status(params[:status_index])
            .page(1) 
        else
            @bookings = Booking.search(params[:query])
            .search(params[:query])
            .get_status(params[:status_index])
            .page(1) 
        end 
    end
end
