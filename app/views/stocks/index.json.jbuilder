json.array!(@stocks) do |stock|
  json.extract! stock, :id, :qte, :ressource_id, :stockable_id, :stockable_type, :type
  json.url stock_url(stock, format: :json)
end
