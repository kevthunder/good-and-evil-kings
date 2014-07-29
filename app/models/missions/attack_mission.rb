class AttackMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create

  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','returning'])
  end

  def start_going
    create_movement :going
    garrisons.subtract_from castle
  end
  
  def end_going
    movement.destroy! unless movement.nil?
    battle
    self.next_event = Time.now + calcul_travel_time
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    garrisons.add_to castle
    stocks.add_to castle
  end
  
  def battle
    # kill stuff
    cost = garrisons.attack_cost(target)
    transaction do
      cost[:us].subtract_from(self)
      cost[:them].subtract_from(target)
      # loot
      target.stocks.up_to_date.give_any(self,garrisons.carry)
    end
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom != kingdom
    end
    
    def needs_field_garrisons
      true
    end
  end
  
  private

  def start
    self.next_event = Time.now + calcul_travel_time
    super
  end
end