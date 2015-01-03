class Tile < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true
  belongs_to :tiled, polymorphic: true
  after_initialize :default_values
    
  
  
  
  def distance(point)
    Math.hypot(point.x - x, point.y - y)
  end
  
  scope :rendered, (lambda do 
    Tile.where(render: true)
  end)
  
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
  
  scope :within_square_dist, (lambda do |point,dist|
    inBounds(Zone.new(point.x - dist, point.y - dist, point.x + dist, point.y + dist))
  end)
  
  
  class << self
    def new_from_point(pt,options={})
      new(options.merge( {x:pt.x, y:pt.y} ))
    end
    
    def find_empty_spot(zone,min_spacing)
      existing_zone = zone.expand(min_spacing)
      existing_tiles = inBounds(existing_zone).to_a
      
      max_tries = 200
      i = 0
      loop do 
        pos = zone.random_point
        return pos if existing_tiles.none?{ |tile| pos.distance(tile) < min_spacing }
        return nil if i > max_tries
      end
    end
  end
  
  private
    
    def default_values
      if new_record?
        self.render = true if self.render.nil?
      end
    end
  
end
