class Ai < ActiveRecord::Base
  belongs_to :castle
  
  include Updated
  updated_column :next_action, :do_any_action
  
  def init
      self.next_action ||= DateTime.now
  end
  
  def do_any_action()
    self.do_action
    save
  end
  
  def do_action(action = nil)
    action = AiAction.random_executable_for self if action.nil?
    action = AiAction.find_by_type(action) unless action.respond_to?(:execute_for)
    action.execute_for self unless action.nil?
    self.next_action = DateTime.now + rand(12.hour..36.hour)
  end
  
  class << self
    def create_scattered(point,max_side_size)
      ai = avalable_for_size(max_side_size)
    end
    def avalable_for_size(max_side_size)
    
    end
  end
end
