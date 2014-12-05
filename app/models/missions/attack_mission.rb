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
    battle = Battle.new(self,target)
    transaction do
      battle.attacker.karma_change = karma_change
      battle.diplomacy_changes(-10,-4)
      battle.apply
      
      Message.new(destination: kingdom, title: 'Battle fought', data: battle.message_data)
      Message.new(destination: target.kingdom, title: 'Battle fought', data: battle.message_data)
      
      target.attacked(self,battle) if target.respond_to?(:attacked)
      destroy if garrisons.qte == 0
    end
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
  
  def intercepted(battle)
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