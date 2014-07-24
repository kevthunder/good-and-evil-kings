class Ai < ActiveRecord::Base
  belongs_to :castle
  
  Updater.add_updated self
  
  def init
      self.next_action ||= DateTime.now
  end
  
  def do_action(action = nil)
    action = AiAction.random_executable_for self if action.nil?
    action = AiAction.find_by_type(action) unless action.respond_to?(:execute_for)
    action.execute_for self unless action.nil?
    self.next_action = DateTime.now + rand(12.hour..36.hour)
  end
  
  def update_event
    if !next_action.nil? && next_action < Time.now
      self.do_action
      save
    end
  end
  
  scope :to_update, -> { where('next_action < ?', Time.now) }
  
  class << self
    def update
      to_update.each do |mission|
        mission.update_event
      end
    end
  end
end
