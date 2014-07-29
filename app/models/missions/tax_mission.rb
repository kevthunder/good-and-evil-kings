class TaxMission < Mission
  has_one :mission_length, as: :target
  
  def mission_length_origin
    mission_length.nil? ? nil : mission_type.mission_lengths.find_by_seconds(mission_length.seconds)
  end
  def mission_length_origin_id 
    mission_length_origin = self.mission_length_origin
    mission_length_origin.nil? ? nil : mission_length_origin.id
  end
  def mission_length_origin_id= val
    mission_length_origin = mission_type.mission_lengths.find(val)
    mission_length = self.mission_length
    mission_length = MissionLength.new if mission_length.nil?
    mission_length.seconds = mission_length_origin.seconds
    mission_length.reward = mission_length_origin.reward
    self.mission_length = mission_length
    mission_length.save
  end
  
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
  
  def start_waiting
    self.next_event = Time.now + length
  end
  
  def remaining 
    (next_event.nil? ? 0 : (next_event - Time.now).second / length) * 0.9 + 0.10
  end
  
  def reward(remaining = 1)
    (target.pop * length * mission_length.reward * remaining / 820).to_i
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
    
    def needs_field_mission_length_origin_id
      true
    end
    
    def opt_length_read_val(opt)
      return TimeAmount.new(opt.val.to_i).pretty
    end
  end
  
end