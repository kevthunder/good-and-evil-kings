class Tile < ActiveRecord::Base
	validates :x, presence: true
	validates :y, presence: true
	belongs_to :tiled, polymorphic: true
end
