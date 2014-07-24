json.array!(@ressources) do |ressource|
  json.extract! ressource, :id, :name, :global
  json.url ressource_url(ressource, format: :json)
end
