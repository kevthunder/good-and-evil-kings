class Zone
  def initialize(x1,y1,x2,y2)  
    @x1,@y1,@x2,@y2 = x1,y1,x2,y2 
  end  
    
  attr_accessor :x1, :y1, :x2, :y2 
    
  def hypot()  
    Math.hypot(x1 - x2, y1 - y2)  
  end  
  
  def ==(other)
    self.class === other and
      other.x1 == @x1 and
      other.y1 == @y1 and
      other.x2 == @x2 and
      other.y2 == @y2
  end
  alias eql? ==

  def hash
    @x1*1000000 + @y1*10000 + @x2*100 + @y2
  end
  class << self
    def tilesToBounds(tiles,tileSize)
      tmpTiles = tiles.dup
      bounds = []
      while tmpTiles.length > 0 do
        includedTiles = []
        includedTiles.push(tmpTiles.shift)
        zone = Zone.new(includedTiles[0].x * tileSize,includedTiles[0].y * tileSize,includedTiles[0].x * tileSize + tileSize,includedTiles[0].y * tileSize + tileSize);
        while tryExtendBound(zone,tmpTiles,:top,tileSize) do end
        while tryExtendBound(zone,tmpTiles,:right,tileSize) do end
        while tryExtendBound(zone,tmpTiles,:bottom,tileSize) do end
        while tryExtendBound(zone,tmpTiles,:left,tileSize) do end
        bounds.push(zone)
      end
      bounds
    end
    
    private
      def tryExtendBound(zone,tiles,direction,tileSize)
        case direction
        when :top
          first = Point.new(zone.x1/tileSize,(zone.y1-1)/tileSize)
          last = Point.new((zone.x2-1)/tileSize,(zone.y1-1)/tileSize)
        when :right
          first = Point.new(zone.x2/tileSize,zone.y1/tileSize)
          last = Point.new(zone.x2/tileSize,(zone.y2-1)/tileSize)
        when :bottom
          first = Point.new(zone.x1/tileSize,zone.y2/tileSize)
          last = Point.new((zone.x2-1)/tileSize,zone.y2/tileSize)
        else
          first = Point.new((zone.x1-1)/tileSize,zone.y1/tileSize)
          last = Point.new((zone.x1-1)/tileSize,(zone.y2-1)/tileSize)
        end
        if tryTakeTilesInterval(tiles,first,last)
          case direction
          when :top
            zone.y1 -= tileSize
          when :right
            zone.x2 += tileSize
          when :bottom
            zone.y2 += tileSize
          else
            zone.x1 -= tileSize
          end
          return true
        end
        false
      end
      
      def tryTakeTilesInterval(tiles,first,last)
        found = tiles.select{ |tile| tile.x >= first.x && tile.y >= first.y && tile.x <= last.x && tile.y <= last.y }
        if found.length == (last.x-first.x+1)*(last.y-first.y+1)
          tiles.reject!{|tile| found.include?(tile)}
          return true
        end
        false
      end
  end
end