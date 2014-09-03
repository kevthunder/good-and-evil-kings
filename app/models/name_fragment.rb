class NameFragment < ActiveRecord::Base

  include Randomizable
  
  class << self
    def default_format
      "%{adj} %{noun}"
    end
    
    def random_part(group,pos)
      where(group: group, pos: pos).random
    end
    
    def generate_name(group,format=default_format)
      res = format
      res.gsub(/%\{([^}]+)\}/) do |match| 
        random_part(group,$1).name
      end
    end
    
    def generate_until(group,format=default_format)
      max_tries = 200
      i = 0
      loop do 
        name = generate_name(group,format)
        i += 1
        return nil if i > max_tries
        return name if yield(name)
      end 
    end
    
  end
end
