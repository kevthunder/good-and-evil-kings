class Point
  def initialize(x,y)  
    @x, @y = x,y  
  end  
    
  attr_reader :x, :y  
    
  def distance(point)  
    Math.hypot(point.x - x, point.y - y)  
  end  
  
  def self.unserialize(string)
    string.split(',')
      .map{ |pair|
         split = pair.split(';')
         Point.new(split[0].to_i,split[1].to_i)
       }
  end
  
  def ==(other)
    self.class === other and
      other.x == @x and
      other.y == @y
  end
  alias eql? ==

  def hash
    @x*1000 + @y
  end
  
end