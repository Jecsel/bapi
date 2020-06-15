json.slots @schedule.slots do |slot|
    json.extract! slot, :id, :slot_time
    json.slot_time_to slot.slot_time + @schedule.minute_interval.minutes
    json.status !slot.status && slot.allocations == 0 ? "fully_booked" : !slot.status && slot.allocations != 0 ? "deleted" : "active"
end