class TradeMission < Mission
  validate :garrisons_must_carry, on: :create

  def after_initialize()
    add_sequence(['going','returning'])
  end
  
  class << self
    def needs_field_stocks
      true
    end
  end
  
  def end_going
    movement.destroy! unless movement.nil?
    battle
    self.next_event = Time.now + calcul_travel_time
  end
    
  private
  
  def garrisons_can_carry?
    castle.garrisons.ready.find_by_type('Trade cart').carry < stocks.qte
  end
  
  def garrisons_must_carry
    errors.add(:stocks, 'must have at least one soldier') if garrisons_can_carry? 
  end

  def start
    garrisons.create()
    self.next_event = Time.now + calcul_travel_time
    super
  end
end