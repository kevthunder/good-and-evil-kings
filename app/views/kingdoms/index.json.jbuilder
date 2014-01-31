json.array!(@kingdoms) do |kingdom|
  json.extract! kingdom, :id, :name, :user_id, :karma
  json.url kingdom_url(kingdom, format: :json)
end
