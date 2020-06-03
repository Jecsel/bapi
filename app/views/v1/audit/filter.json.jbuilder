json.audit_logs @audit_log.each do |log|
    json.extract! log, :model, :field_name, :action, :modified_by, :created_at
    case log.model
    when "Setting"
        json.log_text "Updated COVID-19 price from #{log.old_value}RM to #{log.new_value}RM"
    else
        json.log_text "Updated #{log.model} #{log.field_name} from #{log.old_value} to #{log.new_value}"
    end
end
json.counts @audit_log.count
json.total_pages @audit_log.total_pages
json.total_count @audit_log.total_count