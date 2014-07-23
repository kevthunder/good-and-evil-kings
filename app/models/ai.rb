class Ai < ActiveRecord::Base
  belongs_to :castle
  
  Updater.add_updated self
  
  def init
      self.next_action ||= DateTime.now
  end
  
  def do_action
    action = AiAction.random_executable_for self
    action.execute_for self unless action.nil?
  end
  
  def update_event
    if !next_action.nil? && next_action < Time.now
      self.do_action
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
