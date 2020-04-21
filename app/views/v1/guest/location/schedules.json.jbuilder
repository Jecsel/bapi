json.extract! @loc, :id, :name, :address
json.active_slot do 
    json.status @schedules.any?
    json.data @schedules.first.slots.group_by(&:meridian) if @schedules.any?
end
json.schedules @schedules, :id, :schedule_date