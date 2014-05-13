json.array!(@buildings) do |building|
  json.extract! building, :id, :x, :y, :building_type_id, :castle_id, :ready
  json.url building_url(building, format: :json)
end
