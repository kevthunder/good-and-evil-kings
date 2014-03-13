json.array!(@missions) do |mission|
  json.extract! mission, :id, :type, :mission_status_id, :castle_id, :target_id, :target_type, :next_event
  json.url mission_url(mission, format: :json)
end
