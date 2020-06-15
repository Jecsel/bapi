json.schedules @schedules do |sched|
   json.extract! sched , :id, :schedule_date, :allocation_per_slot, :morning_start_time, :morning_end_time, :afternoon_start_time, :afternoon_end_time
   json.total_allocated_slot sched.slots.count * sched.allocation_per_slot
   json.available_slot sched.slots.count_total_available_slots
   json.booked_slot sched.bookings.count
end   
json.total_pages @schedules.total_pages
json.total_count @schedules.total_count