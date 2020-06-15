json.user_list @users.each do |user|
    json.extract! user, :id, :username
end
json.counts @audit_log.count
json.total_pages @audit_log.total_pages
json.total_count @audit_log.total_count