class InterceptionMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create
  validate :must_be_within_reach, on: :create
  
  belongs_to :interception_tile, class_name: "Tile", dependent: :destroy

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
    cost = garrisons.attack_cost(target)
    transaction do
      self.garrisons.subtract cost[:us]
      target.garrisons.subtract cost[:them]
      # loot
      stocks.add(target.stocks.up_to_date.subtract_any(garrisons.carry))
      # karma
      castle.kingdom.change_karma(karma_change)
      castle.kingdom.save
      target.intercepted(cost) if target.respond_to?(:intercepted)
    end
  end
  
  def karma_change
    self_reduction = 2
    multiply = 0.5
    kdiff = castle.kindom.karma+target.target.kindom.karma-target.castle.kindom.karma+(target.target.kindom.karma+target.castle.kindom.karma)/-2
    (
      kdiff > 0 ? 
        v(kdiff)*multiply
      : v(-kdiff)*-multiply
    )
  end
  
  def calcul_interception_point
    return false unless target.respond_to?(:interceptable) && target.interceptable
    Point::intercept_movement(target.castle,target.cur_pos,target.garrisons.speed,castle,garrisons.speed)
  end
  
  def must_be_within_reach
    errors.add(:garrisons, ' soldiers are not fast enough to intercept in time') unless calcul_interception_point
  end
  
  def target_tile
    interception_tile
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:interceptable) && target.interceptable
    end
    
    def needs_field_garrisons
      true
    end
  end
  
  private

  def start
    ipt = calcul_interception_point
    interception_tile = Tile.new(x: ipt.x, y: ipt.y)
    self.next_event = Time.now + calcul_travel_time
    super
  end
end