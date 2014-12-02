json.array!(@message_categories) do |message_category|
  json.extract! message_category, :id, :title
  json.url message_category_url(message_category, format: :json)
end
