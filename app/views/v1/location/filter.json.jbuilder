json.location_list @locations do |location|
    json.extract! location, :id, :name, :address, :longitude, :latitude, :code, :referral_type
    json.status location.status ? "Active" : "Inactive"
end
json.counts @locations.count
json.total_pages @locations.total_pages
json.total_count @locations.total_count
