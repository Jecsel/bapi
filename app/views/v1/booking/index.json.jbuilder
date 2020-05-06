json.location_list @locations.each do |location|
    json.extract! location, :id, :name
end
json.controls @role_policy do |rol|
    json.extract! rol.service_policy, :id, :status
end