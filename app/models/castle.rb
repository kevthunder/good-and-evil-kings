class Castle < ActiveRecord::Base
  belongs_to :kingdom
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  has_many :incomes, ->{ extending Quantifiable::HasManyExtension }, as: :stockable, inverse_of: :stockable
  has_many :stocks, -> { extending(Quantifiable::HasManyExtension).where(type: nil) }, as: :stockable
  has_many :stocks_raw, ->{ extending Quantifiable::HasManyExtension }, class_name: :Stock, as: :stockable
  has_many :garrisons, ->{ extending Garrison::HasManyExtension }, as: :garrisonable
  has_many :buildings
  serialize :elevations_map, Array
  
  include Modifiable
  prop_mod :max_stock, default: 1000
  prop_mod "income:1"
  prop_mod "income:2"
  prop_mod "income:3"
  
  def stocks
    incomes.apply(self)
    super
  end
  
  def max_stock(stock = nil)
    super()
  end
  
  def default_income(id)
    10
  end
  
  def income(id,val)
    income = incomes.where(ressource_id: id.to_i).first
    if income.nil?  
      if new_record?
        incomes.new(ressource_id: id.to_i,qte: val.to_i)
      else
        incomes.create(ressource_id: id.to_i,qte: val.to_i)
      end
    else
      income.qte = val.to_i
      income.save!
    end
  end
  
  def on_stock_empty(income)
    garrisons.get_upkeep_equiv(income).subtract_from(self)
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
