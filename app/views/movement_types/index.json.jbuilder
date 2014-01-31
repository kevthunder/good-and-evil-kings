json.array!(@movement_types) do |movement_type|
  json.extract! movement_type, :id, :name
  json.url movement_type_url(movement_type, format: :json)
end
