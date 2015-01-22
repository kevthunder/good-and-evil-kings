class Building < ActiveRecord::Base
  belongs_to :building_type
  belongs_to :castle
  has_many :upgrades, through: :building_type
  validate :dont_overlapse, :in_bounds, :on_flat_land, :must_respect_max
  validate :must_upgrade, on: :update, :if => :building_type_id_changed?
  validate :must_be_basic, on: :create
  has_one :owner, through: :castle
  
  include Buyable
  self.buyer = :castle
  self.buyable_type = :building_type
  
  include ModApplier
  apply_mods_to :castle, provider: :building_type, direct: false
  
  def dont_overlapse
    errors.add(:base, "Cant place building on top of each other.") if overlapse?
  end
  
  def overlapse?
    Building.where.not(id: id).overlapsing(self).count > 0
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
  
  def must_respect_max
    errors.add(:base, "This castle allready have the maximum buildings of that type") unless respect_max?
  end
  
  def respect_max?
    return true if building_type.max_instances.nil? || building_type.max_instances.zero?
    castle.buildings.with_base_type(building_type).where.not(id: id).count < building_type.max_instances
  end
  
  def must_be_basic
    if bougth
      errors.add(:building_type_id, "This is an upgrade, it cant be build directly") unless building_type.predecessor_id.nil?
    end
  end
  
  def must_upgrade
    if bougth
      errors.add(:building_type_id, " can't be upgraded to") unless building_type.predecessor_id == building_type_id_was
    end
  end
  
  def bounds
    Point.new(16,16)
  end
  
  def can_upgrade?
    upgrades.count > 0
  end
  
  def owned_by?(user)
    !user.nil? && !owner.nil? && owner.id == user.id
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
  
  scope :with_base_type, (lambda do |building_type|
    base_id = building_type.base_id || building_type.id
    joins(:building_type).where("building_types.base_id = :base_id OR building_types.id = :base_id",{base_id:base_id})
  end)
  
  scope :upgradable, (lambda do ||
    joins(:upgrades)
  end)
  
  class << self
    
  end
  private
  
  def elev_zone
    Zone.new(x / 2,y / 2,(x + building_type.size_x - 1) / 2,(y + building_type.size_y - 1) / 2)
  end
end
