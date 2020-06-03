json.array! @audit_log do |log|
    json.datetime log.created_at.strftime("%b %d, %Y %I:%M:%S %p")
    json.module_name log.model
    json.action log.action
    case log.model
    when "Setting"
        json.log_text "Updated COVID-19 price from #{log.old_value}RM to #{log.new_value}RM"
    when "Users"
        json.log_text "Changed role of #{UserRole.find(log.field_id).user.username} from #{log.old_value} to #{log.new_value}"
    when "Bookings"
        case log.field_name
        when "booking_id"
            json.log_text "Added payment details for booking ##{log.field_id}"
        when "booking_status"
            json.log_text "Confirmed booking ##{log.field_id}"
        when "booking_schedule"
            json.log_text "Rescheduled booking ##{log.field_id} from #{log.old_value} to #{log.new_value}"
        when "booking_cancel"
            json.log_text "Cancelled booking ##{log.field_id}"
        when "booking_export"
            json.log_text log.new_value
        end
    else
        json.log_text "#{log.action} #{log.model} #{log.field_name} from #{log.old_value} to #{log.new_value}"
    end
    json.modified_by log.modified_by
end