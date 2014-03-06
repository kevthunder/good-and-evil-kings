class Castle < ActiveRecord::Base
  belongs_to :kingdom
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  has_many :stocks, as: :stockable
  has_many :garrisons, as: :garrisonable
  
  accepts_nested_attributes_for :tile
  accepts_nested_attributes_for :stocks, :garrisons, allow_destroy: true
  
  default_scope :include => :kingdom
end
