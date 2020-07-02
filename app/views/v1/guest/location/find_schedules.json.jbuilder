json.schedules @schedule.slots.active do |skd|
    json.extract! skd, :id, :status
    json.slot_time_with_interval skd.slot_time_with_interval
end
json.has_available_slot @schedule.slots.active.any?
