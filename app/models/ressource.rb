class Ressource < ActiveRecord::Base
  def alias
    name.parameterize('_')
  end
  
  def find(r)
    if r.is_a? Ressource
      r
    elsif ressource.is_a?(String) || ressource.is_a?(Symbol)
      find_by_name(ressource)
    else
      super(r)
    end
  end
  
  class << self
    Ressource.all.each do |r| 
      define_method(r.alias) do ||
        r
      end
    end
  end
end
