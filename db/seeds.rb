MissionStatus.create!([
  {name: "Going", code: "going"},
  {name: "Occupying", code: "occupying"},
  {name: "Returning", code: "returning"}
])
MissionType.create!([
  {name: "Attack", class_name: "AttackMission"},
  {name: "Trade", class_name: "TradeMission"},
  {name: "Movement", class_name: "MovementMission"}
])
Ressource.create!([
  {name: "Food"},
  {name: "Wood"},
  {name: "Stone"},
  {name: "Coins"},
  {name: "Noble coins"}
])
SoldierType.create!([
  {name: "Footman", speed: 5, attack: 10, defence: 3, interception: 5, carry: 10},
  {name: "Light Cavalry", speed: 10, attack: 5, defence: 3, interception: 10, carry: 20},
  {name: "Archer", speed: 7, attack: 3, defence: 10, interception: 5, carry: 15}
])
