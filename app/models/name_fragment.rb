class NameFragment < ActiveRecord::Base

  include Randomizable
  
  class << self
    def random_part(group,pos)
      where(group: group, pos: pos).random
    end
    
    def generate_name(group,format="%{adj} %{noun}")
      res = format
      res.gsub(/%\{([^}]+)\}/) do |match| 
        random_part(group,$1).name
      end
    end
  end
end
