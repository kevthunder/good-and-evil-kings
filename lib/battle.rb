class BattleSide
  def initialize(battle,side,key)
    @battle, @side, @key = battle, side, key
  end
  attr_accessor :battle, :side, :key, :karma_change
  
  
  attr_writer :power
  def power
    return @power unless @power.nil?
    battle.calcul_cost
    @power
  end
  
  attr_writer :cost
  def cost
    return @cost unless @cost.nil?
    battle.calcul_cost
    @cost
  end
  
  attr_writer :loot
  def loot
    return @loot unless @loot.nil?
    battle.calcul_cost
    @loot
  end
  
  attr_writer :start_garrisons
  def start_garrisons end
    return @start_garrisons unless @start_garrisons.nil?
    battle.calcul_cost
    @start_garrisons
  end
  
  def end_garrisons end
    return @end_garrisons unless @end_garrisons.nil?
    @end_garrisons = start_garrisons.subtract(cost)
  end
  
  
  def message_data
    origin = side
    origin = side.castle if side.class.model_name.to_s == 'Mission'
    {
      origin_id: origin.id,
      origin_type: origin.class.model_name.to_s,
      start_garrisons: start_garrisons.to_h,
      cost: cost.to_h,
      loot: loot.to_h,
      karma_change: karma_change
    }
  end
  
end

class Battle
  def initialize(attacker,defender,type = :attack)
    @attacker, @defender, @type = BattleSide.new(self,attacker,:attacker),BattleSide.new(self,defender,:defender), type
  end
  attr_accessor :attacker, :defender, :type
  
  def winner
    return @winner unless @winner.nil?
    calcul_winner
    @winner
  end
  
  def loser
    return @loser unless @loser.nil?
    calcul_winner
    @loser
  end
  
  def calcul_winner
    if defender.power / attacker.power.to_f  > 3 / 4.to_f
      @winner = attacker
      @loser = defender
    elsif attacker.power / defender.power.to_f  > 3 / 4.to_f
      @winner = defender
      @loser = attacker
    else
      @winner = false
      @loser = false
    end
  end
  
  def message_data
    {
      winner: winner.key,
      attacker: attacker.message_data,
      defender: defender.message_data
    }
  end
  
  def calcul_cost
    types = {
      attack: {:att => 'attack',:def => 'defence'},
      interception: {:att => 'interception',:def => 'interception'}
    }
    att_start_garrisons = attacker.garrisons.ready.military
    attacker.start_garrisons = att_start_garrisons.to_collection.dup
    att_data = att_start_garrisons.get_battle_data(types[type][:att])
    attacker.power = att_data.sum { |d| d[:power] }
    def_start_garrisons = defender.garrisons.ready.military
    defender.start_garrisons = def_start_garrisons.to_collection.dup
    def_data = def_start_garrisons.get_battle_data(types[type][:def])
    defender.power = def_data.sum { |d| d[:power] }
    
    
    cost = [attacker.power,defender.power,[attacker.power,defender.power].sum * 3 / 8].min
    
    attacker.cost = side_cost(cost,att_data,attacker.power,defender.power)
    defender.cost = side_cost(cost,def_data,defender.power,attacker.power)
    
    defender.loot = attacker.loot = Stock.new_collection()
    winner.loot = loser.side.stocks.up_to_date.take_any(winner.end_garrisons.carry) if winner
    
    { attacker: attacker.cost, defender: defender.cost }
  end

  def side_cost(cost,my_data,my_power,their_power)
    ratio = my_power / their_power
    
    # http://www.meta-calculator.com/online/ulsb8hvniq3c
    my_ratio =  if ratio < 1
                  1
                elsif ratio < 2
                  (ratio-1)**3/-4.0+1.0
                else
                  (ratio+1.0)/(ratio-1.0)/4.0
                end
    
    remaining = my_data.sum { |d| d[:qte] }
    deads = (remaining * cost / my_power.to_f * my_ratio).ceil
    
    Garrison.new_collection(my_data.map do |d| 
      this_deads = d[:qte] * deads / remaining
      deads -= this_deads
      remaining -= d[:qte]
      Garrison.new(qte: this_deads, soldier_type_id: d[:type]) 
    end)
  end
end