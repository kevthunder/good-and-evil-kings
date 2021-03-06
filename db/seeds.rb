#################### Ressources ####################
ressources = Hash[Ressource.create!([
  {name: "Food",        global: nil},
  {name: "Wood",        global: nil},
  {name: "Stone",       global: nil},
  {name: "Coins",       global: true},
  {name: "Noble coins", global: true}
]).map{ |r| [r.alias.to_sym, r] }]

#################### Ai Actions ####################
AiAction.create!([
  {type: "BuildAction",   weight: 100, allways: false},
  {type: "RecruteAction", weight: 100, allways: false},
  {type: "AttackAction",  weight: 100, allways: false},
  {type: "TaxAction",     weight: nil, allways: true},
  {type: "UpgradeAction", weight: 100, allways: false}
])
#################### Building Types ####################
building_types = Hash[BuildingType.create!([
  {name: "Casern", type: "CasernBuilding", build_time: nil, size_x: 2, size_y: 2, max_instances: 1,
    costs: [
      {qte: 500, ressource: ressources[:wood]},
      {qte: 500, ressource: ressources[:stone]},
      {qte: 100, ressource: ressources[:coins]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "recruitable_qty", num: 10.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Farm", type: "", build_time: nil, size_x: 2, size_y: 2, 
    costs: [
      {qte: 200, ressource: ressources[:wood]},
      {qte: 200, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:food].id}", num: 20.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "House", type: "", build_time: nil, size_x: 2, size_y: 2,
    costs: [
      {qte: 200, ressource: ressources[:wood]},
      {qte: 20, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "pop", num: 5.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Warehouse", type: "", build_time: nil, size_x: 2, size_y: 2, max_instances: 2,
    costs: [
      {qte: 150, ressource: ressources[:wood]},
      {qte: 150, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "max_stock", num: 1000.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Wood camp", type: "", build_time: nil, size_x: 2, size_y: 2,
    costs: [
      {qte: 100, ressource: ressources[:wood]},
      {qte: 200, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:wood].id}", num: 10.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Mine", type: "", build_time: nil, size_x: 2, size_y: 2,
    costs: [
      {qte: 200, ressource: ressources[:wood]},
      {qte: 100, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:stone].id}", num: 10.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
]).map{ |r| [r.alias.to_sym, r] }]

#################### Building Types (Level 2) ####################
BuildingType.create!([
  {name: "Farm 2", type: "", build_time: nil, size_x: 2, size_y: 2, predecessor: building_types[:farm], base: building_types[:farm],
    costs: [
      {qte: 150, ressource: ressources[:wood]},
      {qte: 150, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:food].id}", num: 30.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  }
])

#################### Soldier Types ####################
SoldierType.create!([
  {name: "Footman", speed: 5, attack: 10, defence: 3, interception: 5, carry: 10, recrute_time: 600, military: true, alias: "footman",
    costs: [
      {qte: 20, ressource: ressources[:coins]},
      {qte: 10, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:food].id}", num: -1.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Light Cavalry", speed: 10, attack: 5, defence: 3, interception: 10, carry: 20, recrute_time: 600, military: true, alias: "light_cavalry",
    costs: [
      {qte: 25, ressource: ressources[:coins]},
      {qte: 10, ressource: ressources[:wood]},
      {qte: 10, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:food].id}", num: -1.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Archer", speed: 7, attack: 3, defence: 10, interception: 5, carry: 15, recrute_time: 600, military: true, alias: "archer",
    costs: [
      {qte: 15, ressource: ressources[:coins]},
      {qte: 10, ressource: ressources[:wood]}
    ].map{|d| Stock.new(d)},
    modificators: [
      {prop: "income:#{ressources[:food].id}", num: -1.0, multiply: false}
    ].map{|d| Modificator.new(d)}
  },
  {name: "Trade cart", speed: 8, attack: nil, defence: nil, interception: nil, carry: 50, recrute_time: 800, military: false, alias: "trade_cart",
    costs: [
      {qte: 10, ressource: ressources[:coins]},
      {qte: 10, ressource: ressources[:wood]},
      {qte: 10, ressource: ressources[:stone]}
    ].map{|d| Stock.new(d)}
  },
  {name: "Worker", speed: 8, attack: nil, defence: nil, interception: nil, carry: 20, recrute_time: 400, military: false, alias: "worker",
    costs: [
      {qte: 20, ressource: ressources[:food]},
    ].map{|d| Stock.new(d)}
  }
])

#################### Mission Status ####################
MissionStatus.create!([
  {name: "Going",     code: "going"},
  {name: "Occupying", code: "occupying"},
  {name: "Returning", code: "returning"},
  {name: "Working",   code: "working"},
  {name: "Ready",     code: "ready"}
])

#################### Mission Types ####################
MissionType.create!([
  {name: "Attack", class_name: "AttackMission"},
  {name: "Trade", class_name: "TradeMission"},
  {name: "Movement", class_name: "MovementMission"},
  {name: "Collect Taxes", class_name: "TaxMission",
    mission_lengths: [
      {label: "15 min", seconds: 900,   reward: 1.0},
      {label: "30 min", seconds: 1800,  reward: 0.9},
      {label: "1 h",    seconds: 3600,  reward: 0.8},
      {label: "2 h",    seconds: 7200,  reward: 0.7},
      {label: "6 h",    seconds: 21600, reward: 0.6},
      {label: "12 h",   seconds: 43200, reward: 0.5},
      {label: "23 h",   seconds: 82800, reward: 0.4},
    ].map{|d| MissionLength.new(d)}
  },
  {name: "Assist Mission", class_name: "AssistMission",
    mission_lengths: [
      {label: "15 min", seconds: 900,   reward: 1.0},
      {label: "30 min", seconds: 1800,  reward: 0.9},
      {label: "1 h",    seconds: 3600,  reward: 0.8},
      {label: "2 h",    seconds: 7200,  reward: 0.7},
      {label: "6 h",    seconds: 21600, reward: 0.6},
      {label: "12 h",   seconds: 43200, reward: 0.5},
      {label: "23 h",   seconds: 82800, reward: 0.4},
    ].map{|d| MissionLength.new(d)}
  },
  {name: "Interception", class_name: "InterceptionMission"},
  {name: "Defence", class_name: "DefenceMission",
    mission_lengths: [
      {label: "30 min", seconds: 1800,   reward: nil},
      {label: "2 h",    seconds: 7200,   reward: nil},
      {label: "12 h",   seconds: 43200,  reward: nil},
      {label: "46 h",   seconds: 165600, reward: nil},
    ].map{|d| MissionLength.new(d)}
  }
])

#################### Name Fragments ####################
NameFragment.create!([
  {name: "kingdom", pos: "noun", group: "kingdom"},
  {name: "dominion", pos: "noun", group: "kingdom"},
  {name: "empire", pos: "noun", group: "kingdom"},
  {name: "guards", pos: "noun", group: "kingdom"},
  {name: "wardens", pos: "noun", group: "kingdom"},
  {name: "guardians", pos: "noun", group: "kingdom"},
  {name: "sentinels", pos: "noun", group: "kingdom"},
  {name: "shields", pos: "noun", group: "kingdom"},
  {name: "swords", pos: "noun", group: "kingdom"},
  {name: "squires", pos: "noun", group: "kingdom"},
  {name: "champions", pos: "noun", group: "kingdom"},
  {name: "fighters", pos: "noun", group: "kingdom"},
  {name: "heros", pos: "noun", group: "kingdom"},
  {name: "combatants", pos: "noun", group: "kingdom"},
  {name: "conquerors", pos: "noun", group: "kingdom"},
  {name: "defenders", pos: "noun", group: "kingdom"},
  {name: "protectors", pos: "noun", group: "kingdom"},
  {name: "soldiers", pos: "noun", group: "kingdom"},
  {name: "warlords", pos: "noun", group: "kingdom"},
  {name: "warriors", pos: "noun", group: "kingdom"},
  {name: "legionnaires", pos: "noun", group: "kingdom"},
  {name: "mercenaries", pos: "noun", group: "kingdom"},
  {name: "elites", pos: "noun", group: "kingdom"},
  {name: "nobles", pos: "noun", group: "kingdom"},
  {name: "aristocrats", pos: "noun", group: "kingdom"},
  {name: "arbiters", pos: "noun", group: "kingdom"},
  {name: "experts", pos: "noun", group: "kingdom"},
  {name: "wizards", pos: "noun", group: "kingdom"},
  {name: "chieftains", pos: "noun", group: "kingdom"},
  {name: "captains", pos: "noun", group: "kingdom"},
  {name: "barbarians", pos: "noun", group: "kingdom"},
  {name: "monsters", pos: "noun", group: "kingdom"},
  {name: "beasts", pos: "noun", group: "kingdom"},
  {name: "foxes", pos: "noun", group: "kingdom"},
  {name: "hounds", pos: "noun", group: "kingdom"},
  {name: "wolves", pos: "noun", group: "kingdom"},
  {name: "dogs", pos: "noun", group: "kingdom"},
  {name: "dragons", pos: "noun", group: "kingdom"},
  {name: "giants", pos: "noun", group: "kingdom"},
  {name: "titans", pos: "noun", group: "kingdom"},
  {name: "behemoths", pos: "noun", group: "kingdom"},
  {name: "leviathans", pos: "noun", group: "kingdom"},
  {name: "horrors", pos: "noun", group: "kingdom"},
  {name: "lions", pos: "noun", group: "kingdom"},
  {name: "aces", pos: "noun", group: "kingdom"},
  {name: "shadows", pos: "noun", group: "kingdom"},
  {name: "settlers", pos: "noun", group: "kingdom"},
  {name: "colonists", pos: "noun", group: "kingdom"},
  {name: "foreigners", pos: "noun", group: "kingdom"},
  {name: "denizens", pos: "noun", group: "kingdom"},
  {name: "pioneers", pos: "noun", group: "kingdom"},
  {name: "explorers", pos: "noun", group: "kingdom"},
  {name: "founders", pos: "noun", group: "kingdom"},
  {name: "sages", pos: "noun", group: "kingdom"},
  {name: "geniuses", pos: "noun", group: "kingdom"},
  {name: "intellectuals", pos: "noun", group: "kingdom"},
  {name: "scholars", pos: "noun", group: "kingdom"},
  {name: "immortals", pos: "noun", group: "kingdom"},
  {name: "monarchs", pos: "noun", group: "kingdom"},
  
  {name: "king's", pos: "adj", group: "kingdom"},
  {name: "queen's", pos: "adj", group: "kingdom"},
  {name: "nature's", pos: "adj", group: "kingdom"},
  {name: "gods's", pos: "adj", group: "kingdom"},
  {name: "fox's", pos: "adj", group: "kingdom"},
  {name: "dragon's", pos: "adj", group: "kingdom"},
  {name: "blue", pos: "adj", group: "kingdom"},
  {name: "giants", pos: "adj", group: "kingdom"},
  {name: "red", pos: "adj", group: "kingdom"},
  {name: "dark", pos: "adj", group: "kingdom"},
  {name: "green", pos: "adj", group: "kingdom"},
  {name: "crimson", pos: "adj", group: "kingdom"},
  {name: "blood's", pos: "adj", group: "kingdom"},
  {name: "divine", pos: "adj", group: "kingdom"},
  {name: "righteous", pos: "adj", group: "kingdom"},
  {name: "faithful", pos: "adj", group: "kingdom"},
  {name: "angelic", pos: "adj", group: "kingdom"},
  {name: "godly", pos: "adj", group: "kingdom"},
  {name: "godlike", pos: "adj", group: "kingdom"},
  {name: "corrupt", pos: "adj", group: "kingdom"},
  {name: "evil", pos: "adj", group: "kingdom"},
  {name: "unholy", pos: "adj", group: "kingdom"},
  {name: "celestial", pos: "adj", group: "kingdom"},
  {name: "blessed", pos: "adj", group: "kingdom"},
  {name: "sacred", pos: "adj", group: "kingdom"},
  {name: "astral", pos: "adj", group: "kingdom"},
  {name: "divine", pos: "adj", group: "kingdom"},
  {name: "fearless", pos: "adj", group: "kingdom"},
  {name: "gutsy", pos: "adj", group: "kingdom"},
  {name: "heroic", pos: "adj", group: "kingdom"},
  {name: "valiant", pos: "adj", group: "kingdom"},
  {name: "brave", pos: "adj", group: "kingdom"},
  {name: "fast", pos: "adj", group: "kingdom"},
  {name: "quick", pos: "adj", group: "kingdom"},
  {name: "swift", pos: "adj", group: "kingdom"},
  {name: "dashing", pos: "adj", group: "kingdom"},
  {name: "everlasting", pos: "adj", group: "kingdom"},
  {name: "immovable", pos: "adj", group: "kingdom"},
  {name: "unyielding", pos: "adj", group: "kingdom"},
  {name: "adamant", pos: "adj", group: "kingdom"},
  {name: "steadfast", pos: "adj", group: "kingdom"},
  {name: "cold", pos: "adj", group: "kingdom"},
  {name: "fiery", pos: "adj", group: "kingdom"},
  {name: "burning", pos: "adj", group: "kingdom"},
  {name: "fierce", pos: "adj", group: "kingdom"},
  {name: "violent", pos: "adj", group: "kingdom"},
  {name: "ablazed", pos: "adj", group: "kingdom"},
  {name: "gentle", pos: "adj", group: "kingdom"},
  {name: "choleric", pos: "adj", group: "kingdom"},
  {name: "ardent", pos: "adj", group: "kingdom"},
  {name: "enraged", pos: "adj", group: "kingdom"},
  {name: "enlightened", pos: "adj", group: "kingdom"},
  {name: "cunning", pos: "adj", group: "kingdom"},
  {name: "ingenious", pos: "adj", group: "kingdom"},
  {name: "sharp", pos: "adj", group: "kingdom"},
  {name: "emerald", pos: "adj", group: "kingdom"},
  {name: "ruby", pos: "adj", group: "kingdom"},
  {name: "jade", pos: "adj", group: "kingdom"},
  {name: "colossal", pos: "adj", group: "kingdom"},
  {name: "monstrous", pos: "adj", group: "kingdom"},
  {name: "gigantic", pos: "adj", group: "kingdom"},
  {name: "humongous", pos: "adj", group: "kingdom"},
  {name: "herculean", pos: "adj", group: "kingdom"},
  {name: "dwarf", pos: "adj", group: "kingdom"},
  {name: "yellow", pos: "adj", group: "kingdom"},
  {name: "amber", pos: "adj", group: "kingdom"},
  {name: "crystal", pos: "adj", group: "kingdom"},
  {name: "ashen", pos: "adj", group: "kingdom"},
  {name: "iron", pos: "adj", group: "kingdom"},
  {name: "azure", pos: "adj", group: "kingdom"},
  {name: "cobalt", pos: "adj", group: "kingdom"},
  {name: "indigo", pos: "adj", group: "kingdom"},
  {name: "royal", pos: "adj", group: "kingdom"},
  {name: "white", pos: "adj", group: "kingdom"},
  {name: "silver", pos: "adj", group: "kingdom"},
  {name: "ivory", pos: "adj", group: "kingdom"},
  {name: "eternal", pos: "adj", group: "kingdom"},
  {name: "immortal", pos: "adj", group: "kingdom"},
  {name: "undying", pos: "adj", group: "kingdom"},
  {name: "purple", pos: "adj", group: "kingdom"},
  {name: "lavender", pos: "adj", group: "kingdom"},
  {name: "amethyst", pos: "adj", group: "kingdom"},
  {name: "orange", pos: "adj", group: "kingdom"},
  {name: "coral", pos: "adj", group: "kingdom"},
  {name: "stone", pos: "adj", group: "kingdom"},
  {name: "bronze", pos: "adj", group: "kingdom"},
  {name: "copper", pos: "adj", group: "kingdom"},
  {name: "gold", pos: "adj", group: "kingdom"},
  
  {name: "castle", pos: "noun", group: "castle"},
  {name: "acropolis", pos: "noun", group: "castle"},
  {name: "fort", pos: "noun", group: "castle"},
  {name: "citadel", pos: "noun", group: "castle"},
  {name: "donjon", pos: "noun", group: "castle"},
  {name: "fortress", pos: "noun", group: "castle"},
  {name: "keep", pos: "noun", group: "castle"},
  {name: "stronghold", pos: "noun", group: "castle"},
  {name: "tower", pos: "noun", group: "castle"},
  {name: "bastion", pos: "noun", group: "castle"},
  {name: "camp", pos: "noun", group: "castle"},
  {name: "garrison", pos: "noun", group: "castle"},
  {name: "city", pos: "noun", group: "castle"},
  {name: "domain", pos: "noun", group: "castle"},
  {name: "metropolis", pos: "noun", group: "castle"},
  {name: "town", pos: "noun", group: "castle"},
  {name: "burg", pos: "noun", group: "castle"},
  {name: "hill", pos: "noun", group: "castle"},
  {name: "mountain", pos: "noun", group: "castle"},
  {name: "peak", pos: "noun", group: "castle"},
  {name: "bank", pos: "noun", group: "castle"},
  {name: "lake", pos: "noun", group: "castle"},
  {name: "lagoon", pos: "noun", group: "castle"},
  {name: "river", pos: "noun", group: "castle"},
  {name: "creek", pos: "noun", group: "castle"},
  {name: "spring", pos: "noun", group: "castle"},
  {name: "field", pos: "noun", group: "castle"},
  {name: "land", pos: "noun", group: "castle"},
  {name: "wall", pos: "noun", group: "castle"},
  {name: "refuge", pos: "noun", group: "castle"},
  {name: "den", pos: "noun", group: "castle"},
  {name: "stone", pos: "noun", group: "castle"},
  {name: "rock", pos: "noun", group: "castle"},
  {name: "mine", pos: "noun", group: "castle"},
  {name: "mines", pos: "noun", group: "castle"},
  {name: "fountain", pos: "noun", group: "castle"},
  {name: "mill", pos: "noun", group: "castle"},
  
  {name: "king's", pos: "adj", group: "castle"},
  {name: "queen's", pos: "adj", group: "castle"},
  {name: "nature's", pos: "adj", group: "castle"},
  {name: "gods's", pos: "adj", group: "castle"},
  {name: "fox's", pos: "adj", group: "castle"},
  {name: "dragon's", pos: "adj", group: "castle"},
  {name: "blue", pos: "adj", group: "castle"},
  {name: "red", pos: "adj", group: "castle"},
  {name: "dark", pos: "adj", group: "castle"},
  {name: "green", pos: "adj", group: "castle"},
  {name: "crimson", pos: "adj", group: "castle"},
  {name: "blood's", pos: "adj", group: "castle"},
  {name: "divine", pos: "adj", group: "castle"},
  {name: "angelic", pos: "adj", group: "castle"},
  {name: "godly", pos: "adj", group: "castle"},
  {name: "corrupt", pos: "adj", group: "castle"},
  {name: "evil", pos: "adj", group: "castle"},
  {name: "unholy", pos: "adj", group: "castle"},
  {name: "celestial", pos: "adj", group: "castle"},
  {name: "blessed", pos: "adj", group: "castle"},
  {name: "sacred", pos: "adj", group: "castle"},
  {name: "astral", pos: "adj", group: "castle"},
  {name: "divine", pos: "adj", group: "castle"},
  {name: "everlasting", pos: "adj", group: "castle"},
  {name: "immovable", pos: "adj", group: "castle"},
  {name: "unyielding", pos: "adj", group: "castle"},
  {name: "adamant", pos: "adj", group: "castle"},
  {name: "steadfast", pos: "adj", group: "castle"},
  {name: "cold", pos: "adj", group: "castle"},
  {name: "fiery", pos: "adj", group: "castle"},
  {name: "burning", pos: "adj", group: "castle"},
  {name: "ablazed", pos: "adj", group: "castle"},
  {name: "choleric", pos: "adj", group: "castle"},
  {name: "ardent", pos: "adj", group: "castle"},
  {name: "emerald", pos: "adj", group: "castle"},
  {name: "ruby", pos: "adj", group: "castle"},
  {name: "jade", pos: "adj", group: "castle"},
  {name: "colossal", pos: "adj", group: "castle"},
  {name: "monstrous", pos: "adj", group: "castle"},
  {name: "gigantic", pos: "adj", group: "castle"},
  {name: "humongous", pos: "adj", group: "castle"},
  {name: "herculean", pos: "adj", group: "castle"},
  {name: "yellow", pos: "adj", group: "castle"},
  {name: "amber", pos: "adj", group: "castle"},
  {name: "crystal", pos: "adj", group: "castle"},
  {name: "ashen", pos: "adj", group: "castle"},
  {name: "iron", pos: "adj", group: "castle"},
  {name: "azure", pos: "adj", group: "castle"},
  {name: "cobalt", pos: "adj", group: "castle"},
  {name: "indigo", pos: "adj", group: "castle"},
  {name: "royal", pos: "adj", group: "castle"},
  {name: "white", pos: "adj", group: "castle"},
  {name: "silver", pos: "adj", group: "castle"},
  {name: "ivory", pos: "adj", group: "castle"},
  {name: "eternal", pos: "adj", group: "castle"},
  {name: "immortal", pos: "adj", group: "castle"},
  {name: "undying", pos: "adj", group: "castle"},
  {name: "purple", pos: "adj", group: "castle"},
  {name: "lavender", pos: "adj", group: "castle"},
  {name: "amethyst", pos: "adj", group: "castle"},
  {name: "orange", pos: "adj", group: "castle"},
  {name: "coral", pos: "adj", group: "castle"},
  {name: "stone", pos: "adj", group: "castle"},
  {name: "bronze", pos: "adj", group: "castle"},
  {name: "copper", pos: "adj", group: "castle"},
  {name: "gold", pos: "adj", group: "castle"}
])
