json.active_slot do 
    json.status @schedules.any?
    json.data @schedules.last.slots.group_by(&:meridian) if @schedules.any?
end
json.has_available_slot @schedules.last.slots.available.any?