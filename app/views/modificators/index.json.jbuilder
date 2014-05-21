json.array!(@modificators) do |modificator|
  json.extract! modificator, :id, :prop, :num, :multiply, :modifiable_id, :modifiable_type, :applier_id, :applier_type
  json.url modificator_url(modificator, format: :json)
end
