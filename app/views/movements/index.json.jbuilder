json.array!(@movements) do |movement|
  json.extract! movement, :id, :start_time, :start_tile_id, :end_tile_id
  json.url movement_url(movement, format: :json)
end
