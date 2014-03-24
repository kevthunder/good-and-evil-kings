class Castle < ActiveRecord::Base
  belongs_to :kingdom
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  has_many :stocks, as: :stockable
  has_many :garrisons, as: :garrisonable

  def x
    tile.x
  end

  def y
    tile.y
  end

  def distance(point)
    Math.hypot(point.x - x, point.y - y)
  end

  accepts_nested_attributes_for :tile
  accepts_nested_attributes_for :stocks, :garrisons, allow_destroy: true

  default_scope { includes(:kingdom) }
end
