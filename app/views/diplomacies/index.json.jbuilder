json.array!(@diplomacies) do |diplomacy|
  json.extract! diplomacy, :id, :karma, :from_kingdom_id, :to_kingdom_id, :last_interaction
  json.url diplomacy_url(diplomacy, format: :json)
end
