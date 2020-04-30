json.policies @policies do |pol|
    json.service_name Service.find(pol[0]).name
    json.service_path Service.find(pol[0]).resource_path
    json.service_icon Service.find(pol[0]).resource_icon
    json.service_order Service.find(pol[0]).resource_order
    json.controls pol[1].each do |pol|
        json.extract! pol.service_policy, :id, :name, :status
    end
end