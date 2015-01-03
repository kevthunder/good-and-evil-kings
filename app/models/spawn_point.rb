class SpawnPoint < ActiveRecord::Base
  belongs_to :castle
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  
  def x
    tile.x
  end

  def y
    tile.y
  end
  
  class << self
    def get_available_or_create
      available = SpawnPoint.where(castle_id: nil).first
      return available unless available.nil?
    
      delta = SpawnPoint.maximum(:delta) || 0
      
      pos = ( Point.square_circle_around(delta)*100 ).move_random(30)
      
      SpawnPoint.new( delta: delta, tile: Tile.new_from_point(pos, render: false) )
    end
  end
end
