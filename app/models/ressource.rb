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
  
    def persistent
      debugger
      return @persistent unless @persistent.nil? 
      @persistent = Ressource.all.inject({}) do |hash,ressource|
        hash[r.alias] = r
        hash
      end
    end
    
    def method_missing(method_name, *arguments, &block)
      if !method_name =~ /^@/ && persistent.has_key?(method_name)
        persistent[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      (!method_name =~ /^@/ && persistent.has_key?(method_name)) || super
    end
    
  end
end
