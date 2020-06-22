json.extract! @loc, :id, :name, :address
json.schedules @schedules do |skd|
   json.extract! skd, :id, :schedule_date 
   json.has_available_slot skd.slots.available.any?
end