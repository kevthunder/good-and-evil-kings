class Point
  def initialize(x,y)  
    @x, @y = x,y  
  end  
    
  attr_accessor :x, :y  
    
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
  
  
  
  class << self
    # Point::intercept_movement(Point.new(200,200),Point.new(0,0),2,Point.new(0,100),2)
    def intercept_movement(pt1,pt2,speed,pt_origin,my_speed)
      # dist =  Math::hypot( pt2.x - pt1.x, pt2.y - pt1.y)
      
      if pt2.y == pt1.y
        p1x = pt1.y
        p1y = pt1.x
        p2x = pt2.y
        p2y = pt2.x
        pox = pt_origin.y
        poy = pt_origin.x
      else
        p1x = pt1.x
        p1y = pt1.y
        p2x = pt2.x
        p2y = pt2.y
        pox = pt_origin.x
        poy = pt_origin.y
      end
      
      pixel_ratio = (p2x-p1x)/(p2y-p1y).to_f
      # quadratic formula a b and c
      qqa = (pixel_ratio**2+1)*(speed**2-my_speed**2)
      qqb = 2*(speed**2*(pixel_ratio*(p1x-pox-p1y)-poy)   +   p1y*my_speed**2*(pixel_ratio**2+1))
      qqc = speed**2*((p1y*pixel_ratio+pox-p1x)**2 + poy**2) - p1y**2*(pixel_ratio**2+1) * my_speed**2  

      if qqa == 0
        max_y = p2y
        min_y = -qqc/qqb
        p min_y
        return false if (p2y > p1y)? min_y < p1y : min_y > p1y
      else
        max_y = (-qqb+Math::sqrt(qqb**2-4*qqa*qqc))/2.00/qqa
        min_y = (-qqb-Math::sqrt(qqb**2-4*qqa*qqc))/2.00/qqa
      end
      p min_y
      p max_y
      
      
      max_y = (p2y > p1y)? [max_y,p2y.to_f].min : [max_y,p2y.to_f].max
      min_y = (p2y > p1y)? [min_y,p1y.to_f].max : [min_y,p1y.to_f].min
      
      p min_y
      p max_y
      
      return false if (p2y > p1y)? min_y > max_y : min_y < max_y
      
      y = (max_y-min_y)/2.00 + min_y
      x = (y-p1y)/(p2y-p1y).to_f * (p2x-p1x) + p1x
      
      return pt2.y == pt1.y ? Point.new(y.to_i,x.to_i) : Point.new(x.to_i,y.to_i)
    end
  end
end