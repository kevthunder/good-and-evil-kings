class Movement < ActiveRecord::Base
  belongs_to :start_tile, class_name: "Tile", dependent: :destroy
  belongs_to :end_tile, class_name: "Tile", dependent: :destroy
  
  after_create :bind_tiles
  
  accepts_nested_attributes_for :start_tile, :end_tile
  
  def bind_tiles
    if start_tile.tiled.nil?
      start_tile.tiled = self 
      start_tile.save
    end
    if end_tile.tiled.nil?
      end_tile.tiled = self 
      end_tile.save
    end
  end
  
  def prc
    [1,( DateTime.now - start_time) / (end_time - start_time)].min
  end
  
  def cur_pos
    at_line_prc(start_tile,end_tile,prc);
  end
end
