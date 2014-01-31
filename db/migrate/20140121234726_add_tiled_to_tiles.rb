class AddTiledToTiles < ActiveRecord::Migration
  def change
    add_reference :tiles, :tiled, polymorphic: true, index: true
  end
end
