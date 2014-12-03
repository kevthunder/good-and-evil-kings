class AttackMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create

  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','returning'])
  end
  
  def start_going
    create_movement :going
    castle.garrisons.subtract garrisons
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
    castle.garrisons.add garrisons
    castle.stocks.add stocks
  end
  
  def battle
    # kill stuff
    cost = battle_cost
    transaction do
      self.garrisons.subtract cost[:us]
      target.garrisons.subtract cost[:them]
      # loot
      stocks.add(target.stocks.up_to_date.subtract_any(garrisons.carry))
      # karma
      kingdom.change_karma(karma_change)
      kingdom.save
      kingdom.change_diplomacy(target.kingdom_id,-10,-4)
      
      
      target.attacked(self,cost) if target.respond_to?(:attacked)
      destroy if garrisons.qte == 0
    end
  end
  
  def battle_cost
    garrisons.attack_cost(target)
  end
  
  def karma_change
    self_reduction = 4
    spread = 200
    base = 20
    kdiff = target.kingdom.karma - kingdom.karma / self_reduction
    (
      kdiff > 0 ? 
        (1/(kdiff/ spread+1)-2)*base
      : (1/(kdiff/-spread+1)*base)*-1
    )
  end

  def interceptable
    mission_status_code == 'going'
  end
  
  def intercepted(cost)
    destroy if garrisons.qte == 0
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom != kingdom
    end
    
    def needs_field_garrisons
      true
    end
  end
  
  def reset_movement
    self.next_event = Time.now + calcul_travel_time
    movement.destroy!
    create_movement((mission_status_code == 'going') ? :going : :returning)
  end
  
  private

  def start
    garrisons.set_kingdom(kingdom)
    self.next_event = Time.now + calcul_travel_time
    super
  end
end