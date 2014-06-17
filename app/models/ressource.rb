class Ressource < ActiveRecord::Base
  def alias
    name.parameterize(string, '_')
  end
end
