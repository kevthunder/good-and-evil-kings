class Tile < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true
  belongs_to :tiled, polymorphic: true

  def distance(point)
    Math.hypot(point.x - x, point.y - y)
  end

  scope :inBounds, (lambda do |bounds|
    bounds = [bounds] unless bounds.respond_to?('each')

    or_conds = Array.new
    replace = {}
    i = 0
    bounds.each do |bound|
      or_conds.push "(x >= :x#{i} AND x < :x#{i}b AND y >= :y#{i} AND y < :y#{i}b)"
      replace[:"x#{i}"] = bound.x1
      replace[:"y#{i}"] = bound.y1
      replace[:"x#{i}b"] = bound.x2
      replace[:"y#{i}b"] = bound.y2
      i += 1
    end

    Tile.where(or_conds.join(' OR '), replace)
  end)
end
