json.array!(@missions) do |mission|
  json.extract! mission, :id, :mission_type_id, :mission_status_id
  json.url mission_url(mission, format: :json)
end
