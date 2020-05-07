json.active_slot do 
    json.status @schedules.any?
    json.data @data
end
json.has_available_slot @schedules.last.slots.available.any?