class Tile < ActiveRecord::Base
	validates :x, presence: true
	validates :y, presence: true
	belongs_to :tiled, polymorphic: true
  
  scope :inBounds, ->(bounds) {
    unless bounds.respond_to?('each')
      bounds = [bounds];
    end
  
    cond = "";
    replace = {}
    i = 0
    bounds.each do |bound|
      if cond.length > 0
         cond += " OR "
      end
      cond += "(x >= :x#{i} AND x < :x#{i}b AND y >= :y#{i} AND y < :y#{i}b)"
      replace[:"x#{i}"] = bound.x1
      replace[:"y#{i}"] = bound.y1
      replace[:"x#{i}b"] = bound.x2
      replace[:"y#{i}b"] = bound.y2
      i += 1
    end
    
    Tile.where(cond,replace)
  }
end
