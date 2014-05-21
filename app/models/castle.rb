class Castle < ActiveRecord::Base
  belongs_to :kingdom
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  has_many :incomes, -> { where(type: 'Income') }, as: :stockable
  has_many :stocks, -> { where(type: nil) }, as: :stockable
  has_many :garrisons, as: :garrisonable
  has_many :buildings
  serialize :elevations_map, Array
  
  def stocks
    incomes.apply(self)
    super
  end

  def x
    tile.x
  end

  def y
    tile.y
  end
  
  def owned_by?(user)
    !user.nil? && kingdom.user_id == user.id
  end
  
  def elevations(save=false)
    if @elevations.nil?
      @elevations = Elevations.new(elevations_map)
      @elevations.on_gen do |e|
        self.elevations_map = e.map
      end
      if elevations_map.nil? || elevations_map.count == 0
        @elevations.gen
        self.save! if save
      end
    end
    @elevations
  end

  def distance(point)
    Math.hypot(point.x - x, point.y - y)
  end
  
  accepts_nested_attributes_for :tile
  accepts_nested_attributes_for :stocks, :garrisons, allow_destroy: true

  default_scope { includes(:kingdom) }
end
