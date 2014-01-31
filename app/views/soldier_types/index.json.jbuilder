json.array!(@soldier_types) do |soldier_type|
  json.extract! soldier_type, :id, :name
  json.url soldier_type_url(soldier_type, format: :json)
end
