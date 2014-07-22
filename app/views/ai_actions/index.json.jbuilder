json.array!(@ai_actions) do |ai_action|
  json.extract! ai_action, :id, :type, :weigth
  json.url ai_action_url(ai_action, format: :json)
end
