json.array!(@building_types) do |building_type|
  json.extract! building_type, :id, :name, :type
  json.url building_type_url(building_type, format: :json)
end
