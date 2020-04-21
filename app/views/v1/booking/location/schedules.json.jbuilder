json.extract! @loc, :id, :name, :address
json.schedules @_schedules do |sched|
    json.extract! sched, :id, :schedule_date
end