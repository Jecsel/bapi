json.array! @data do |location|
	json.extract! location, :name, :address
end