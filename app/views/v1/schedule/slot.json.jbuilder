json.extract! @_slot, :id, :slot_time, :is_deleted
json.slot_allocation @_slot.schedule.allocation_per_slot
json.available @_slot.allocations 
json.slot_time_to @_slot.slot_time + @_slot.schedule.minute_interval.minutes
json.status slot.is_deleted ? "Deleted" : @status
json.booked @booking_count