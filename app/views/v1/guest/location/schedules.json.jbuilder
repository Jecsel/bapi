json.extract! @loc, :id, :name, :address
# json.active_slot do 
#     json.status @schedules.any?
#     json.data @schedules.first.slots.group_by(&:meridian) if @schedules.any?
# end
json.schedules @schedules do |skd|
   json.extract! skd, :id, :schedule_date 
   json.has_available_slot skd.slots.available.any?
end