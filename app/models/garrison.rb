class Garrison < ActiveRecord::Base
  belongs_to :kingdom
  belongs_to :soldier_type
  belongs_to :garrisonable, polymorphic: true
  
  
  scope :qte, ->() {
    sum("qte")
  }
  scope :speed, ->() {
    joins(:soldier_type).minimum("soldier_types.speed")
  }
  scope :attack, ->() {
    joins(:soldier_type).sum("soldier_types.attack * qte")
  }
  scope :defence, ->() {
    joins(:soldier_type).sum("soldier_types.defence * qte")
  }
  scope :interception, ->() {
    joins(:soldier_type).sum("soldier_types.interception * qte")
  }
  scope :travel_time_between, ->(pos1,pos2) {
    (pos1.distance(pos2) / speed() + 10)*64;
  }
end
