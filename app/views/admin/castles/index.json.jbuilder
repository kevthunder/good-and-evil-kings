json.array!(@castles) do |castle|
  json.extract! castle, :id, :name, :kingdom_id, :elevations_map, :incomes_date, :max_stock, :pop
  json.url castle_url(castle, format: :json)
end
