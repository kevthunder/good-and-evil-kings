class AiAction < ActiveRecord::Base
  def executable_for(ai)
    false
  end
  
  def execute_for(ai)
    false
  end
  
  scope :randoms, -> { order(ActiveRecordUtil.random_funct+'/weight') }
  
  class << self
    def random
      randoms.first
    end
    
    def random_executable_for(ai)
      randoms.each do |a|
        return a if a.executable_for(ai)
      end
      nil
    end
  end
end
