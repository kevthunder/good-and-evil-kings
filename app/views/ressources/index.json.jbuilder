json.array!(@ressources) do |ressource|
  json.extract! ressource, :id, :name
  json.url ressource_url(ressource, format: :json)
end
