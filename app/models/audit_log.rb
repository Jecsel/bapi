class AuditLog < ApplicationRecord

    enum action:["Added", "Updated", "Exported"]

    def self.log_changes model, field_name, field_id, old_value, new_value, action, user
        
        log             = self.new
        log.model       = model
        log.field_name  = field_name
        log.field_id    = field_id
        log.old_value   = old_value
        log.new_value   = new_value
        log.action      = action
        log.modified_by = user
        log.save
    end

end
