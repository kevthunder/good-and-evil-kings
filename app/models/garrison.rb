class Garrison < ActiveRecord::Base
  belongs_to :kingdom
  belongs_to :soldier_type
  belongs_to :garrisonable, polymorphic: true
  
  
  def self.qte
    sum "qte"
  end
  def self.speed
    joins(:soldier_type).minimum("soldier_types.speed")
  end
  def self.attack
    joins(:soldier_type).sum("soldier_types.attack * qte")
  end
  def self.defence
    joins(:soldier_type).sum("soldier_types.defence * qte")
  end
  def self.interception
    joins(:soldier_type).sum("soldier_types.interception * qte")
  end
  def self.travel_time_between(pos1,pos2)
    Garrison.calcul_travel_time(pos1,pos2,speed)
  end
  
  scope :match_garrisons, ->(garrisons) {
    unless garrisons.respond_to?('each')
      garrisons = [garrisons]
    end
  
    orConds = Array.new
    replace = {}
    i = 0
    garrisons.each do |garrison|
      orConds.push "(soldier_type_id = :soldier_type_id#{i} AND kingdom_id "+(garrison.kingdom_id.nil? ? "IS NULL" :"= :kingdom_id#{i}")+")"
      replace[:"soldier_type_id#{i}"] = garrison.soldier_type_id
      replace[:"kingdom_id#{i}"] = garrison.kingdom_id
      i += 1
    end
    
    where(orConds.join(" OR "),replace)
  }
  
  def self.check_disponibility(garrisons)
    garrisons = garrisons.to_a;
    match = match_garrisons(garrisons).to_a;
    
    garrisons.each do |garrison|
      matched = match.select{ |g|
          g.soldier_type_id == garrison.soldier_type_id && g.kingdom_id == garrison.kingdom_id
        }.first
      return false if (matched.nil? || matched.qte < garrison.qte)
    end
    true
  end
  
  
  
  
  def self.calcul_travel_time(pos1,pos2,speed) 
    ((pos1.distance(pos2) / speed + 10)*64).to_i
  end
end
