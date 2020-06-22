json.slots @schedule.slots do |slot|
    json.extract! slot, :id, :slot_time
    json.slot_time_to slot.slot_time + @schedule.minute_interval.minutes
    if slot.is_deleted 
        json.status "deleted"
    else
        json.status !slot.status && slot.allocations == 0 ? "fully_booked" : "active"
    end 
end