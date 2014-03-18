json.array!(@mission_statuses) do |mission_status|
  json.extract! mission_status, :id, :name, :code
  json.url mission_status_url(mission_status, format: :json)
end
