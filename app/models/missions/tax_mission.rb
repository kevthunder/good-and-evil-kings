class TaxMission < Mission
  include TimedMission
  
  after_initialize :after_initialize
  validate :must_be_alone_ongoing
  
  before_validation do
    if(new_record?)
      self.castle = target
      self.kingdom_id = target.kingdom_id
    end
  end
  
  def must_be_alone_ongoing
    errors.add(:base, "You can't collect tax twice at the same in a castle") unless alone_ongoing?
  end
  
  def alone_ongoing?
    cond = castle.missions.where(type:'TaxMission').ongoing
    cond = cond.where.not(id:id) unless id.nil?
    !cond.any?
  end
  
  def after_initialize()
    add_sequence(['collecting','waiting','expired'])
  end
  
  def start
    self.next_event = Time.now + length
    super
  end
  
  def start_waiting
    self.next_event = Time.now + length
    
    ai = Ai.where(castle_id: castle_id).first
    ai.tax_collected(self) if !ai.nil? && ai.respond_to?(:tax_collected)
  end
  
  def reward(remaining = 1)
    (target.pop * length * reward_prc(remaining) / 720.0).to_i
  end
  
  def redeem
    target.stocks.add_qty(reward(remaining).to_i ,:Coins)
    destroy
  end
  
  def redeemable_status
    ['waiting','expired']
  end
  
  def actions
    actions = super
    if redeemable_status.include?(mission_status_code)
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