json.users @user.each do |u|
    json.extract! u, :username
    json.user_group u.user_role.user_group.name if !u.user_role.nil?
end