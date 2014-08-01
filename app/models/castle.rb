class Castle < ActiveRecord::Base
  belongs_to :kingdom
  has_one :tile, as: :tiled, dependent: :destroy, validate: :true
  has_many :incomes, ->{ extending Quantifiable::HasManyExtension }, as: :stockable, inverse_of: :stockable
  has_many :stocks, -> { extending(Quantifiable::HasManyExtension).where(type: nil) }, as: :stockable, inverse_of: :stockable do
    def add_qty(number, ressource)
      ressource = Ressource.find(ressource)
      if(ressource.global)
        proxy_association.owner.kingdom.stocks.add_qty(number, ressource, proxy_association.owner.kingdom)
      else
        super(number, ressource, proxy_association.owner)
      end
    end
    
    def add(quantifiables)
      quantifiables = new_enumerable(quantifiables)
      proxy_association.owner.kingdom.stocks.add(quantifiables.globals)
      super(quantifiables.locals)
    end
    
    def transfer(quantifiables)
      quantifiables = new_enumerable(quantifiables)
      proxy_association.owner.kingdom.stocks.transfer(quantifiables.globals)
      super(quantifiables.locals)
    end
    
    def up_to_date
      proxy_association.owner.incomes.apply(proxy_association.owner)
      self
    end
  end
  has_many :stocks_raw, ->{ extending Quantifiable::HasManyExtension }, class_name: :Stock, as: :stockable
  has_many :garrisons, ->{ extending Garrison::HasManyExtension }, as: :garrisonable
  has_many :buildings
  serialize :elevations_map, Array
  
  include Modifiable
  prop_mod :max_stock, default: 1000
  prop_mod "income:1"
  prop_mod "income:2"
  prop_mod "income:3"
  
  include Randomizable
  
  def accessible_stocks
    incomes.apply(self)
    Stock.where(
      '("stocks"."stockable_type" = :type AND "stocks"."stockable_id" = :id) OR ("stocks"."stockable_type" = :kindom_type AND "stocks"."stockable_id" = :kindom_id)',
      {id: self.id,
      type: self.class.to_s,
      kindom_id: self.kingdom_id,
      kindom_type: "Kingdom"}
    ).where(type: nil)
  end
  
  def max_stock(ressource = nil)
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
  
  def recruitable_qty
    5
  end
  
  def remaining_recruitable_qty
    recruitable_qty - garrisons.not_ready.count
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
  
  def buyable_buildings()
    if @buyable_buildings.nil?
      @buyable_buildings = Building.buyable_types_for(self.accessible_stocks)
    end
    @buyable_buildings
  end
  
  def buyable_troops()
    if @buyable_troops.nil?
      @buyable_troops = Garrison.buyable_types_for(self.accessible_stocks)
    end
    @buyable_troops
  end
  
  accepts_nested_attributes_for :tile
  accepts_nested_attributes_for :stocks, :garrisons, allow_destroy: true

  default_scope { includes(:kingdom) }
end
