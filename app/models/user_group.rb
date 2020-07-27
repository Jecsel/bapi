class UserGroup < ApplicationRecord
    has_many :role_policies


    def self.get_by_role role_id
        if role_id == 3
            return self.where.not(id: [1,2,6]).order(name: :asc)
        elsif role_id == 1
            return self.where.not(id: [6]).order(name: :asc)
        else
            return self.all
        end
    end


end
