json.array!(@mission_types) do |mission_type|
  json.extract! mission_type, :id, :name, :class_name
  json.url mission_type_url(mission_type, format: :json)
end
