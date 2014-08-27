class DefenceMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create
  
  include TimedMission
  
  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','guarding','returning'])
  end
  
  def start
    garrisons.set_kingdom(castle.kingdom_id)
    self.next_event = Time.now + calcul_travel_time
    super
  end
  
  def start_going
    create_movement :going
    castle.garrisons.subtract garrisons
  end
  
  def end_going
    movement.destroy! unless movement.nil?
  end
  
  def start_guarding
    self.next_event = Time.now + length
    
    target.garrisons.add garrisons
  end
  
  def attacked
    # karma
    castle.kingdom.change_karma(karma_change)
    castle.kingdom.save
  end
  
  def end_guarding
    target.garrisons.subtract_up_to!(garrisons)
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    castle.garrisons.add garrisons
  end
  
  def karma_change
    # http://www.meta-calculator.com/online/dufjcy5psemz
    self_reduction = 4
    reduction = 200
    spread = 200
    base = 1
    kmod = 9
    kdiff = target.kingdom.karma - castle.kingdom.karma / self_reduction + reduction
    (
      kdiff < 0 ? 
        (-1/(kdiff/spread-1) -1)*kmod +base
      : (-1/(kdiff/spread+1) +1)*kmod +base
    )
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom != kingdom
    end
    
    def needs_field_garrisons
      true
    end
  end
  
end