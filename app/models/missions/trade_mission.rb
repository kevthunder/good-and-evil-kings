class TradeMission < Mission
  validate :garrisons_must_carry, on: :create
  validate :must_have_some_goods, on: :create

  def after_initialize()
    add_sequence(['going','returning'])
  end
  
  def start_going
    create_movement :going
    garrisons.subtract_from castle
    stocks.subtract_from castle
  end
  
  def end_going
    movement.destroy! unless movement.nil?
    stocks.add_to target
  end
  
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    garrisons.add_to castle
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
    castle.garrisons.ready.find_by_type(:trade_cart).carry < stocks.qte
  end
  
  def garrisons_must_carry
    errors.add(:stocks, 'not enough trade carts to carry those goods') if garrisons_can_carry? 
  end
  
  def must_have_some_goods
    errors.add(:stocks, 'not enough trade carts to carry those goods') if stocks.qte < 0
  end

  def start
    type = SoldierType.find_by_machine_name(:trade_cart)
    garrisons.create(qte: stocks.qte/type.carry, kingdom_id: castle.kingdom_id, soldier_type: type)
    self.next_event = Time.now + calcul_travel_time
    super
  end
end