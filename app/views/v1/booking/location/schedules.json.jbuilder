json.extract! @loc, :id, :name, :address
json.today_schedule do 
    json.status @today_schedule.any?
    json.extract! @today_schedule.last, :id, :schedule_date if @today_schedule.any?
    json.slots []
end
json.future_schedules @future_schedules, :id, :schedule_date