json.active_slot do 
    json.status !@schedule.nil?
    json.data @schedule.slots.group_by(&:meridian) if !@schedule.nil?
end