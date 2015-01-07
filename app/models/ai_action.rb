class AiAction < ActiveRecord::Base
  include Randomizable
  extend InheritenceBaseNaming

  def executable_for(ai)
    false
  end
  
  def execute_for(ai)
    false
  end
  
  class << self
    
    def random_executable_for(ai)
      randoms.each do |a|
        return a if a.executable_for(ai)
      end
      nil
    end
  end
end
