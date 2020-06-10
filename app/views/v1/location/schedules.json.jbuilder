json.schedules @schedules do |sched|
   json.extract! sched , :id, :schedule_date, :allocation_per_slot
   json.morning_start_time sched.morning_start_time
   json.morning_end_time sched.morning_end_time
   json.afternoon_start_time sched.afternoon_start_time
   json.afternoon_end_time sched.afternoon_end_time
end   
json.total_pages @schedules.total_pages
json.total_count @schedules.total_count