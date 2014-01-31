class Movement < ActiveRecord::Base
  belongs_to :start_tile
  belongs_to :end_tile
end
