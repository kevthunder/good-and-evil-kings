class InterceptionMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create
  validate :must_be_within_reach, on: :create
  
  has_one :interception_tile, as: :tiled, class_name: "Tile", dependent: :destroy

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
  end
  
  def start_returning
    self.next_event = Time.now + calcul_travel_time
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    castle.garrisons.add garrisons
    castle.stocks.add stocks
  end
  
  def battle
    unless target.nil?
      # kill stuff
      battle = Battle.new(self,target,:interception)
      transaction do
        battle.attacker.karma_change = karma_change
        battle.diplomacy_changes(-10,0)
        battle.apply
        
        Message.create!(destination: kingdom, title: 'Battle fought', data: battle.message_data)
        Message.create!(destination: target.kingdom, title: 'Battle fought', data: battle.message_data)
        
        target.intercepted(battle) if target.respond_to?(:intercepted)
        destroy if garrisons.qte == 0
      end
    end
    
    
  end
  
  def karma_change
    self_reduction = 2
    multiply = 0.5
    kdiff = kingdom.karma+target.target.kingdom.karma-target.kingdom.karma+(target.target.kingdom.karma+target.kingdom.karma)/-2
    (
      kdiff > 0 ? 
        Math.sqrt(kdiff)*multiply
      : Math.sqrt(-kdiff)*-multiply
    )
  end
  
  def calcul_interception_point
    return false unless target.respond_to?(:interceptable) && target.interceptable
    Point::intercept_movement(target.cur_pos,target.target,target.garrisons.speed,castle,garrisons.speed)
  end
  
  def calcul_travel_time
    if mission_status_code.nil? || mission_status_code == 'going'
      target.garrisons.travel_time_between(target.cur_pos, interception_tile)
    else
      super
    end
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
    self.interception_tile = Tile.new(x: ipt.x, y: ipt.y, render: false)
    self.next_event = Time.now + calcul_travel_time
    super
  end
end