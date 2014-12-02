json.array!(@messages) do |message|
  json.extract! message, :id, :title, :text, :destination_id, :destination_type, :sender_id, :sender_type, :data, :template
  json.url message_url(message, format: :json)
end
