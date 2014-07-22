json.array!(@ais) do |ai|
  json.extract! ai, :id, :castle_id, :next_action
  json.url ai_url(ai, format: :json)
end
