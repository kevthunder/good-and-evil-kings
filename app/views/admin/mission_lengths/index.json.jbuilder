json.array!(@mission_lengths) do |mission_length|
  json.extract! mission_length, :id, :label, :seconds, :reward, :target_id, :target_type
  json.url mission_length_url(mission_length, format: :json)
end
