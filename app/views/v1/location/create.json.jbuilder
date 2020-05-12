json.location do 
    json.extract! @location, :id, :address, :code, :name, :longitude, :latitude, :referral_type
    json.status @location.status ? "Active" : "Inactive"
end