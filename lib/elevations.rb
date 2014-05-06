class Elevations
  attr_reader :map, :width, :height  
  
  def initialize(map = nil,width = 8,height = 8)
    @map, @width, @height = map, width, height
  end  

  def gen(width = @width, height = @height)
    @width, @height = width, height
    @map = Array.new(width*height, 0)
    niv = width*height/4
    place_elevation() while @map.last == 0
    @on_gen.call(self) unless @on_gen.nil?
    self
  end
  
  def on_gen(&block)
    @on_gen = block;
  end
  
  def matrix
    @map.each_slice(width).to_a
  end
  
  def each_points
    matrix.each_with_index do |row,y|
      row.each_with_index do |elevation,x|
        yield(x,y,elevation)
      end
    end
  end
  
  def each_display_order
    (0..max_slice_dist).each do |dist|
      slice_each(dist) do |x,y|
        yield(x,y,elevation(x,y))
      end
    end
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
    return nil unless (0..width-1).include?(x) && (0..height-1).include?(y)
    @map[y*width+x] = val unless val.nil?
    @map[y*width+x]
  end
  
  def place_elevation
    # Todo : diagonal repartition
    # x >= MAX(0,d - (h - 1))
    # x <= MIN((w - 1),d)
    # y = d – x
    # d <= w + h - 2
  
    dist = max_slice_dist
    pos = rnd_diagonal_slice_pos(dist);
    until can_elevate(pos)
      pos = rnd_diagonal_slice_pos(dist)
      dist = (dist==0) ? width + height - 2 : dist-1
    end
    elevation(pos,elevation(pos)+1)
  end
  
  def max_slice_dist
    width + height - 2
  end
  def diagonal_slice(dist)
    [0, dist - height + 1].max..[width - 1, dist].min
  end
  def slice_each(dist)
    diagonal_slice(dist).each do |x|
      yield(x,dist - x)
    end
  end
  
  def rnd_diagonal_slice_pos(dist)
    x = rand(diagonal_slice(dist))
    Point.new(x, dist - x);
  end
  
  def can_elevate(pos)
    e = elevation(pos)
    (pos.x == 0 || elevation(pos.x-1,pos.y)>e) &&
    (pos.y == 0 || elevation(pos.x,pos.y-1)>e) && (
      (pos.x == width - 1 && pos.y == height - 1) ||
      (pos.x != width - 1 && elevation(pos.x+1,pos.y) == e) ||
      (pos.y != height - 1 && elevation(pos.x,pos.y+1) == e)
    ) && (
      pos.x != 0 || pos.y != 0 ||
      (elevation(0,1) == e && elevation(1,0) == e)
    )
  end
end