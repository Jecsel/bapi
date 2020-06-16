json.schedules @schedules.last.slots do |skd|
    json.extract! skd, :id, :status
    json.slot_time_with_interval skd.slot_time_with_interval
end
json.has_available_slot @schedules.last.slots.available.any?
