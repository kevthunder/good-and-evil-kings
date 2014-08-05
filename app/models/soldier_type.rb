class SoldierType < ActiveRecord::Base
  has_many :costs, ->{ extending Quantifiable::HasManyExtension }, class_name: :Stock, as: :stockable
  has_many :modificators, as: :applier

  accepts_nested_attributes_for :costs, :modificators, allow_destroy: true
  
  include Randomizable
  
  alias_attribute :buy_time, :recrute_time
  
  def qty_buyable_for(stocks)
    costs = self.costs.to_collection
    stocks = stocks.match(costs).to_collection
    costs.map{ |c| s = stocks.match(c); s.qte / c.qte }.min
  end
end
