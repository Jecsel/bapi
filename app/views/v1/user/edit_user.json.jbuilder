json.user do
    json.extract! @user, :id, :username
    json.is_active @user.is_active ? 1 : 0
    json.status @user.is_active ? "Active" : "Inactive"
    json.user_group @user.user_role.user_group.name if !@user.user_role.nil?
    json.user_group_id @user.user_role.user_group.id if !@user.user_role.nil?
end