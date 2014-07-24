class AttackAction < AiAction
  def executable_for(ai)
    ai.castle.garrisons.military.count > 20 && targetable_for(ai).count > 0
  end
  
  def max_square_dist
    3000
  end
  
  def targetable_for(ai)
    Castle.joins(:tile).merge(Tile.within_square_dist(ai.castle.tile,max_square_dist)).where.not(kingdom_id: ai.castle.kingdom_id)
  end
  
  def execute_for(ai)
    target = targetable_for(ai).random
    garrisons = ai.castle.garrisons.military.map{ |g| g.dup }
    mission = Mission.new( castle: ai.castle , target:target, garrisons: garrisons, type: "AttackMission" )
    
    mission.save
  end
end