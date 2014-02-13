json.array!(@tiles) do |keyVal|
	json.x keyVal[0].x
	json.y keyVal[0].y
	json.tiles do 
		json.array!(keyVal[1]) do |tile|
		  json.extract! tile, :id, :x, :y
		  json.url tile_url(tile, format: :json)
		end 
	end
end