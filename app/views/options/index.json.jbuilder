json.array!(@options) do |option|
  json.extract! option, :id, :name, :val, :target_id, :target_type
  json.url option_url(option, format: :json)
end
