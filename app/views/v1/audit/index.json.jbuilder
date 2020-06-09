json.audit_logs @audit_log.each do |log|
    json.extract! log, :model, :field_name, :action, :modified_by, :created_at
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
end
json.user_list @users.each do |user|
    json.extract! user, :id, :username
end
json.counts @audit_log.count
json.total_pages @audit_log.total_pages
json.total_count @audit_log.total_count