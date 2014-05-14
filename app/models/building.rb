class Building < ActiveRecord::Base
  belongs_to :building_type
  belongs_to :castle
  validate :dont_overlapse
  
  include Buyable
  alias_method :buyer, :castle
  alias_method :buyable_type, :building_type
  
  def dont_overlapse
    errors.add(:base, "Cant place building on top of each other.") if overlapse?
  end
  
  def overlapse?
    Building.overlapsing(self).count > 0
  end
  
  scope :overlapsing, (lambda do |building|
    where(castle_id: building.castle_id).where("x Between :x1 and :x2 AND y Between :y1 and :y2", {
      x1: building.x,
      x2: building.x + building.building_type.x_size -1,
      y1: building.y,
      y2: building.y + building.building_type.y_size -1,
    })
  end)
end
