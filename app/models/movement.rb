class Movement < ActiveRecord::Base
  belongs_to :start_tile, class_name: "Tile"
  belongs_to :end_tile, class_name: "Tile"
end
