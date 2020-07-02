json.audit_logs @audit_log.each do |log|
    json.extract! log, :model, :field_name, :action, :modified_by, :created_at
    case log.model
    when "Settings"
        json.log_text "Updated COVID-19 price from #{log.old_value}RM to #{log.new_value}RM"
    when "Users"
        case log.field_name
        when "user_status"
            json.log_text "Changed status of #{User.find(log.field_id).username} from #{!log.old_value.to_i.zero? ? "Active" : "Inactive"} to #{!log.new_value.to_i.zero? ? "Active" : "Inactive"}"
        when "user_add"
            json.log_text "#{log.action} #{log.new_value}"
        when "user_role"
            json.log_text "Changed role of #{UserRole.find(log.field_id).user.username} from #{log.old_value.nil? ? "No user group" : log.old_value} to #{log.new_value}"
        else
            json.log_text "#{log.action} #{log.model} #{log.field_name} from #{log.old_value} to #{log.new_value}"
        end
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
        else
            json.log_text "#{log.action} #{log.model} #{log.field_name} from #{log.old_value} to #{log.new_value}"
        end
    when "Clinics"
        json.log_text "#{log.action} clinic ##{log.field_id}" 
    when "Test Sites"
        case log.field_name
        when "location_delete_day"
            json.log_text "#{log.action} test site ##{log.field_id} schedule day on #{log.new_value.to_date.strftime("%d %B %Y")}"
        when "location_delete_slot"
            json.log_text "#{log.action} test site ##{log.field_id} schedule day on #{log.new_value.to_date.strftime("%d %B %Y")}, #{log.new_value}"
        when "location_add_schedule"
            json.log_text log.new_value
        when "location_clinic_link"
            json.log_text "#{log.action} clinic ##{log.new_value} to test site ##{log.field_id}"
        else
            json.log_text "#{log.action} test site ##{log.field_id}"
        end
    when "AuditLogs"
        json.log_text log.new_value
    else
        json.log_text "#{log.action} #{log.model} #{log.field_name} from #{log.old_value} to #{log.new_value}"
    end
end
json.counts @audit_log.count
json.total_pages @audit_log.total_pages
json.total_count @audit_log.total_count