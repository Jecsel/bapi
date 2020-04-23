class RolePolicy < ApplicationRecord
  belongs_to :user_group
  belongs_to :service
  belongs_to :service_policy
end
