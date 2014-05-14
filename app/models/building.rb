class Building < ActiveRecord::Base
  belongs_to :building_type
  belongs_to :castle
  validate :dont_overlapse, :in_bounds, :on_flat_land
  
  include Buyable
  alias_method :buyer, :castle
  alias_method :buyable_type, :building_type
  
  def dont_overlapse
    errors.add(:base, "Cant place building on top of each other.") if overlapse?
  end
  
  def overlapse?
    Building.overlapsing(self).count > 0
  end
  
  def in_bounds
    if x + building_type.size_x - 1 >= bounds.x || x < 0
      errors.add(:x, "is out of bounds.")
    end
    if y + building_type.size_y - 1 >= bounds.x || x < 0
      errors.add(:y, "is out of bounds.")
    end
  end
  
  def on_flat_land
    errors.add(:base, "Must be place on flat land") unless castle.elevations.flat_zone?(elev_zone)
  end
  
  
  def bounds
    Point.new(16,16)
  end
  
  scope :overlapsing, (lambda do |building|
    joins(:building_type).
      where(castle_id: building.castle_id).
      where("x + building_types.size_x > :x1 AND x < :x2 AND y + building_types.size_y > :y1 AND y < :y2", {
        x1: building.x,
        x2: building.x + building.building_type.size_x,
        y1: building.y,
        y2: building.y + building.building_type.size_y,
      })
  end)
  
  private
  
  def elev_zone
    Zone.new(x / 2,y / 2,(x + building_type.size_x - 1) / 2,(y + building_type.size_y - 1) / 2)
  end
end
