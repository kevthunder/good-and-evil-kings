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
    # Point::intercept_movement(Point.new(-100,-100),Point.new(0,0),2,Point.new(100,100),2)
    def at_line_prc(pt1,pt2,prc)
      Point.new(
        (prc * (pt2.x - pt1.x)).to_i + pt1.x,
        (prc * (pt2.y - pt1.y)).to_i + pt1.y
      )
    end
    
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

      sign = (p2y > p1y)? 1 : -1
      if my_speed == speed  # same speed
        max_y = p2y
        min_y = -qqc/qqb
        
        p min_y.to_s + ".." + max_y.to_s
        p p1y.to_s + ".." + p2y.to_s
          
        return false if min_y*sign < p1y*sign || min_y*sign > p2y*sign
      else
        to_sqrt = qqb**2-4*qqa*qqc
        if my_speed > speed # faster
          min_y = (-qqb-Math::sqrt(to_sqrt)*sign)/2.00/qqa
          
          return false if p2y*sign < min_y*sign
          max_y = p2y
        else # slower
          return false if to_sqrt < 0
          max_y = (-qqb+Math::sqrt(to_sqrt))/2.00/qqa
          min_y = (-qqb-Math::sqrt(to_sqrt))/2.00/qqa
          
          return false if (min_y*sign < p1y*sign && max_y*sign < p1y*sign) || (min_y*sign > p2y*sign && max_y*sign > p2y*sign) 
          
          if(p2y > p1y)
            max_y = [max_y,p2y.to_f].min
          else
            min_y = [min_y,p2y.to_f].max
          end
        end
      end
      
      y = (max_y-min_y)/2.00 + min_y
      x = (y-p1y)/(p2y-p1y).to_f * (p2x-p1x) + p1x
      
      return pt2.y == pt1.y ? Point.new(y.to_i,x.to_i) : Point.new(x.to_i,y.to_i)
    end
  end
end