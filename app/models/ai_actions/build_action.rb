class BuildAction < AiAction
  def executable_for(ai)
    ai.castle.buyable_buildings.count > 0 && ai.castle.buildings.count < 64
  end
  
  
  def execute_for(ai)
    type = ai.castle.buyable_buildings.random
    building = Building.new(building_type:type, castle:ai.castle, x:rand(0..7)*2, y:rand(0..7)*2);
    max_tries = 1024
    i = 0
    while building.overlapse? && i < max_tries
      building.x = rand(0..7)*2
      building.y = rand(0..7)*2
      i += 1
    end
    return nil unless i < max_tries
    
    building.bougth = true
    
    building.save
  end
end