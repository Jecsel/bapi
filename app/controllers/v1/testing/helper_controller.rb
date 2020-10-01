class V1::Testing::HelperController < ApplicationController
    before_action :safe_guard
    attr_accessor :test_site

    def biomark_booking_cleanup
        @test_site.bookings.destroy_all
        render json: :cleared
    end
    
    def update_biomark_test_site
        test_site = Location.where("name = ?","BioMark")
        @test_site.update status: params[:state]
        render json: {message: :updated},status: :ok
    end

    def verify_biomark_schedule_presence
        today = DateTime.now.in_time_zone.beginning_of_day
        schedules = @test_site.schedules.where("schedule_date > ?",today).available.order(schedule_date: :asc)
        # render json: schedules
        if schedules.any?
            render json: {message: "schedule exist"},status: :ok
        else
            Scheduler.new schedule_params 
            #TODO generate schedules
            render json: {message: "schedule generated"},status: :ok
        end
        
    end

    private
    def safe_guard
        token = request.headers['access-token']
        if token == ENV['TEST_SCRIPT_ACCESS_TOKEN']
            _test_site = Location.where("name = ?","BioMark")
            if _test_site.any?
                @test_site = _test_site.last
            else
                render json: {message: :test_site_not_found},status: :not_found
            end
            
        else
            render json: {message: :invalid_token},status: :unauthorized
        end
    end
    def schedule_params
        date_today = DateTime.now.in_time_zone
        next_day = date_today + 1.day

        return {
            date_from:next_day, 
            date_to:next_day, 
            location_id: @test_site.id,
            allocation_per_slot:1, 
            minutes_interval:10,
            no_of_session:1,
            first_session:{
                start:{
                    hh:"08", 
                    mm:"00"
                }, 
                end:{
                    hh:"11", 
                    mm:"00"
                }
            },
            second_session:{
                start:{
                    hh:"01", 
                    mm:"00"
                }, 
                end:{
                    hh:"04", 
                    mm:"00"
                }
            },
            days:[
                {
                    is_selected:true,
                    id:0,
                    name:"Mon"
                },
                {
                    is_selected:true,
                    id:1,
                    name:"Tue"
                },
                {
                    is_selected:true,
                    id:2,
                    name:"Wed"
                },
                {
                    is_selected:true,
                    id:3,
                    name:"Thu"
                },
                {
                    is_selected:true,
                    id:4,
                    name:"Fri"
                },
                {
                    is_selected:true,
                    id:5,
                    name:"Sat"
                },
                {
                    is_selected:true,
                    id:6,
                    name:"Sun"
                },
            ]
        }

    end
end
