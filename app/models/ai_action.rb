class AiAction < ActiveRecord::Base
  def executable_for(ai)
    false
  end
  
  def execute_for(ai)
    false
  end
  
  scope :random, -> { all( :order=>'RAND()/weight', :limit => 1 ) }
  
  class << self
    def random_executable_for(ai)
    
    end
  end
end
