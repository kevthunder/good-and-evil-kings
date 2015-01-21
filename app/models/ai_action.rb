class AiAction < ActiveRecord::Base
  include Randomizable
  extend InheritenceBaseNaming

  def executable_for(ai)
    false
  end
  
  def execute_for(ai)
    false
  end
  
  scope :systematic, (lambda do 
    where(allways: true)
  end)
  
  scope :occasional, (lambda do 
    where(allways: false)
  end)
  
  class << self
    
    def random_executable_for(ai)
      randoms.detect do |a|
        a.executable_for(ai)
      end
    end
    
    def executable_for(ai)
      all.select do |a|
        a.executable_for(ai)
      end
    end
  end
end
