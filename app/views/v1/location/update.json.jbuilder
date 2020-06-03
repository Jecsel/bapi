json.location do
    json.extract! @location, :id, :name, :code, :address, :longitude, :latitude, :referral_type
    json.referral_id Location.referral_types[@location.referral_type].to_s
    json.status_id @location.status ? "1" : "0"
    json.status_text @location.status ? "Active": "Inactive"
end