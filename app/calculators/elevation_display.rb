class ElevationDisplay
  class << self
    def top(x,y,elevation,size,subdivision=1)
      x * size / 4 / subdivision + y * size / 4 / subdivision + elevation * size / -8 + size / 2 + 75;
    end
    def left(x,y,elevation,size,subdivision=1)
      x * size / 2 / subdivision + y * size / 2 / subdivision * -1 + size / 2 * 7
    end
  end
end