json.slots @schedule.slots do |slot|
    json.extract! slot, :id, :slot_time
    json.slot_time_to slot.slot_time + @schedule.minute_interval.minutes
end