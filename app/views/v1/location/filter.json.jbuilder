json.locations @locations do |location|
    json.extract! location, :id, :name, :address, :code, :referral_type
    json.status location.status ? "Active" : "Inactive"
end
json.total_pages @locations.total_pages
json.total_count @locations.total_count
