class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :user_group
end
