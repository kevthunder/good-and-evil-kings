class AttackMission < Mission
  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create

  def initialize(id = nil)
    add_sequence(['going','returning'])
    super
  end

  def start_going
    create_movement :going
    garrisons.subtract_from castle
  end
  
  def end_going
    movement.destroy
    battle
    self.next_event = Time.now + calcul_travel_time
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy
  end
  
  def create_movement(direction)
    if direction == :going
      start_tile = castle.tile
      end_tile = target.tile
    else
      start_tile = target.tile
      end_tile = castle.tile
    end
    self.movement = Movement.new(
      start_time: Time.now,
      end_time: next_event,
      start_tile_attributes: {x: start_tile.x, y: start_tile.y},
      end_tile_attributes: {x: end_tile.x, y: end_tile.y}
    )
  end
  
  def battle
    # kill stuff
    cost = garrisons.attack_cost
    cost.us.subtract_from(self)
    cost.them.subtract_from(target)
    # loot
    target.stocks.give_any(self,garrisons.carry)
  end
  
  private

  def unsaved_garrisons
    garrisons.loaded? && garrisons.count == 0 && garrisons.size > 0
  end

  def calcul_travel_time
    return garrisons.travel_time_between(castle, target) unless unsaved_garrisons
    Garrison.calcul_travel_time(castle, target, SoldierType.where(id: garrisons.map { |g| g.soldier_type_id }).minimum('speed'))
  end

  def start
    self.next_event = Time.now + calcul_travel_time
    super
  end
end