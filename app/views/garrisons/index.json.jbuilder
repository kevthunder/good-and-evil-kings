json.array!(@garrisons) do |garrison|
  json.extract! garrison, :id, :qte, :kingdom_id, :soldier_type_id, :garrisonable_id, :garrisonable_type
  json.url garrison_url(garrison, format: :json)
end
