module BelongsToResolver
  extend ActiveSupport::Concern
  
  included do
  end
  
  def resolve_belongs_to_with(loaded)
    self.class.reflect_on_all_associations(:belongs_to).each do |belongs_to|
      foreign_key = self.send(belongs_to.foreign_key)
      model = belongs_to.polymorphic? ? self.send(belongs_to.foreign_type) : belongs_to.klass.model_name
      set_method = belongs_to.name.to_s + "="
      found = loaded.select{ |item| item.class.model_name == model && item.id == foreign_key }
      if found.length > 0 && self.respond_to?(set_method)
        self.send(set_method,found.first)
      end
    end
  end
  
  module ClassMethods
  end
end