json.array!(@tiles) do |tile|
  json.extract! tile, :id, :model, :x, :y
  json.url tile_url(tile, format: :json)
end
