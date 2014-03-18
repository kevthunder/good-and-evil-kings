json.array!(@missions) do |mission|
  json.extract! mission, :id, :type, :castle_id, :target_id, :target_type, :next_event, :mission_status_code
  json.url mission_url(mission, format: :json)
end
