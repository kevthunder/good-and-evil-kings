json.array!(@name_fragments) do |name_fragment|
  json.extract! name_fragment, :id, :name, :pos, :group
  json.url name_fragment_url(name_fragment, format: :json)
end
