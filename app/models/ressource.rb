class Ressource < ActiveRecord::Base
  def alias
    name.parameterize('_')
  end
end
