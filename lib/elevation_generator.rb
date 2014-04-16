class ElevationGenerator
  attr_reader :width, :height  
  
  def initialize(width,height)  
    @map = Array.new(width*height, 0)
    @width, @height = width, height
  end  

  def gen()
    @map = Array.new(width*height, 0)
    niv = width*height/4
    place_elevation() while @map.last == 0
    @map.each_slice(width) { |g| p g }
  end
  
  def elevation(*args)
    throw 'elevation take 1, 2 or 3 arguments' unless (1..3).include?(args.size)
    if args[0].respond_to?(:x) && args[0].respond_to?(:y)
      if args.size==1
        _elevation(args[0].x,args[0].y)
      else
        _elevation(args[0].x,args[0].y,args[1])
      end
    else
      if args.size==2
        _elevation(args[0],args[1])
      else
        _elevation(args[0],args[1],args[2])
      end
    end
  end
  
  private 
  
  def _elevation(x,y,val=nil)
    unless (0..width).include?(x) && (0..height).include?(y)
      p '[' + x.to_s() + ',' + y.to_s() + ']'
    end
    @map[y*width+x] = val unless val.nil?
    @map[y*width+x]
  end
  
  def place_elevation
    # Todo : diagonal repartition
    # x >= MAX(0,d - (h - 1))
    # x <= MIN((w - 1),d)
    # y = d – x
    # d <= w + h - 2
  
    pos = Point.new(width-1,height-1);
    dist = (width,height).max
    until can_elevate(pos)
      if pos.x == 0 || (pos.y > 0 && [true, false].sample)
        pos.y -= 1
      else
        pos.x -= 1
      end
    end
    elevation(pos,elevation(pos)+1)
  end
  
  def can_elevate(pos)
    (pos.x == 0 || elevation(pos.x-1,pos.y)>elevation(pos)) &&
    (pos.y == 0 || elevation(pos.x,pos.y-1)>elevation(pos))
  end
end