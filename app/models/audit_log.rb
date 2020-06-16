class AuditLog < ApplicationRecord

    enum action:["Added", "Updated", "Exported", "Deleted", "Linked", "Unlinked"]

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


    def self.search_filter(filter_params)
        _sql =  get_by_module(filter_params[:module_type])
        if filter_params[:user_id] != 0
            _sql = _sql.get_by_user(filter_params[:user_id])
        end
        if filter_params[:audit_date_start].present? && filter_params[:audit_date_end].present?
            _sql = _sql.where(created_at:[filter_params[:audit_date_start].to_date.beginning_of_day..filter_params[:audit_date_end].to_date.end_of_day])
        end
        if filter_params[:audit_date_start].present? && filter_params[:audit_date_end].nil?
            _sql = _sql.where("created_at >= ?",filter_params[:audit_date_start])
        end
        if filter_params[:audit_date_start].nil? && filter_params[:audit_date_end].present?
            _sql = _sql.where("created_at <= ?",filter_params[:audit_date_end]) 
        end
        return _sql
    end

    def self.get_by_module id 
        if id == 2 #For Test sites module, model/db name is Location/locations
            return where(model: "Locations")
        else
            return where(model: Service.find(id).name) if id != 0
            return self
        end
    end

    def self.get_by_user id 
        return where(modified_by: User.find(id).username) if id != 0
        return self
    end

end
