class RecruteAction < AiAction
  def executable_for(ai)
    ai.castle.buyable_troops.count > 0 && ai.castle.incomes.food.qte > 0 && ai.castle.remaining_recruitable_qty > 0
  end
  
  def execute_for(ai)
    type = ai.castle.buyable_troops.random
    qty = [ ai.castle.remaining_recruitable_qty, type.qty_buyable_for(ai.castle.stocks) ].min
    garrison = Garrison.new( soldier_type: type, qte: qty, castle:ai.castle )
    garrison.recruted = true
    
    building.save
  end
end