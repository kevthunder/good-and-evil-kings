json.array!(@building_types) do |building_type|
  json.extract! building_type, :id, :name, :type, :build_time, :size_x, :size_y, :predecessor_id
  json.url building_type_url(building_type, format: :json)
end
