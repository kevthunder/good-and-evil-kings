class TaxMission < Mission
  has_one :mission_length, as: :target
  
  /*def mission_length_id 
    mission_length.nil? ? nil : mission_length.id
  end
  def mission_length_id= val
    mission_length = MissionLength.find(val)
    self.mission_length = mission_length unless mission_length.nil?
  end*/
  
  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['collecting','waiting'])
  end
  
  def length 
    mission_length.seconds.second
  end
  
  def start
    self.castle = target
    self.next_event = Time.now + length
    super
  end
  
  def redeem
    target.stocks.add((target.pop * (length / 900) ** 0.75).to_i ,:coins,target)
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
    
    def needs_field_mission_length_id
      true
    end
    
    def opt_length_read_val(opt)
      return TimeAmount.new(opt.val.to_i).pretty
    end
  end
  
end