class UserGroup < ApplicationRecord
    has_many :role_policies
end
