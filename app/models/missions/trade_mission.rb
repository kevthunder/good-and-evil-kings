class TradeMission < Mission
  validate :garrisons_must_carry, on: :create
  validate :must_have_some_goods, on: :create
  validate :must_own_goods, on: :create

  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','returning'])
  end
  
  def start_going
    create_movement :going
    castle.garrisons.subtract garrisons
    castle.stocks.subtract stocks
  end
  
  def end_going
    movement.destroy! unless movement.nil?
    target.stocks.add stocks
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    castle.garrisons.add garrisons
  end
  
  class << self
    def allow_target(target,kingdom)
      target.class.model_name == Castle.model_name
    end
    
    def needs_field_stocks
      true
    end
  end
  
    
  def set_carriers
    type = SoldierType.find_by_alias(:trade_cart)
    self.garrisons = [Garrison.new(qte: (stocks.qte/type.carry.to_f).ceil, kingdom_id: castle.kingdom_id, soldier_type: type)]
  end
  
  private
  
  def garrisons_can_carry?
    castle.garrisons.ready.trade_carts.carry >= stocks.qte
  end
  
  def garrisons_must_carry
    errors.add(:stocks, 'not enough trade carts to carry those goods') unless garrisons_can_carry? 
  end
  
  def owns_goods?
    castle.stocks.up_to_date.can_subtract? stocks
  end
  
  def must_own_goods
    errors.add(:stocks, 'not enough trade carts to carry those goods') unless owns_goods?
  end
  
  def must_have_some_goods
    errors.add(:stocks, 'not enough trade carts to carry those goods') if stocks.qte < 0
  end

  
  def start
    garrisons.set_kingdom(castle.kingdom)
    set_carriers
    self.next_event = Time.now + calcul_travel_time
    super
  end
end