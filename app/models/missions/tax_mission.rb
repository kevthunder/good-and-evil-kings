class TaxMission < Mission
  include TimedMission
  
  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['collecting','waiting'])
  end
  
  def start
    self.castle = target
    self.next_event = Time.now + length
    super
  end
  
  def start_waiting
    self.next_event = Time.now + length
  end
  
  def reward(remaining = 1)
    (target.pop * length * reward_prc).to_i
  end
  
  def redeem
    target.stocks.add_qty(reward(remaining).to_i ,:Coins)
    destroy
  end
  
  def actions
    actions = super
    if mission_status_code == "waiting"
      actions.push('redeem')
    end
    actions
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom == kingdom
    end
    
    def needs_field_castle_id
      false
    end
    
    def allow_same_target_and_castle?
      true
    end
  end
  
end