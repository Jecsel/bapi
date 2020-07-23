class User < ApplicationRecord
    before_create :encrypt_password

    has_one :user_role
    has_many :role_policies, through: :user_role

    def valid_password? password
        self.password === Digest::MD5.hexdigest(password)[0..19]
    end

    def self.get_list_by_role role_id
        if role_id == 1 || role_id == 3
            return self.joins(:user_role).where.not(:user_roles => { :user_group_id => 6 })
        else
            return self.all
        end
    end
    
    private

    def encrypt_password
        self.password = Digest::MD5.hexdigest(self.password)[0..19]
    end
    
end
