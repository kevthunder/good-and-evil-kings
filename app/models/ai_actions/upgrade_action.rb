class UpgradeAction < AiAction
  def executable_for(ai)
    ai.castle.buildings.upgradable.any?
  end
  
  
  def execute_for(ai)
    building = random_upgradable_for(ai)
    building.bougth = true
    building.building_type = building.upgrades.first
    building.save!
  end
  
  
  def random_upgradable_for(ai)
    Building.find(ai.castle.buildings.upgradable.pluck(:id).sample)
  end
end