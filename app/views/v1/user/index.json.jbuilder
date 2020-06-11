json.users @user.each do |u|
    json.extract! u, :id, :username
    json.is_active u.is_active ? 1 : 0
    json.status u.is_active ? "Active" : "Inactive"
    json.user_group u.user_role.user_group.name if !u.user_role.nil?
    json.user_group_id u.user_role.user_group.id if !u.user_role.nil?
end
json.user_group_list @user_group.each do |group|
    json.extract! group, :id, :name
end
json.controls @role_policy do |rol|
    json.extract! rol.service_policy, :id, :status
end