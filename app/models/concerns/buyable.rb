module Buyable
  extend ActiveSupport::Concern

  included do
    if self.attribute_method?(:ready)
      include Updated
      updated_column :ready, :on_ready
    
      scope :ready, -> { where(ready: nil) }
      scope :not_ready, -> { where.not(ready: nil) }
    end
    validate :able_to_buy
    before_save :on_bougth
    after_save :buy
  
    attr_accessor :bougth
  end

  def able_to_buy
    if bougth && !can_buy?
      if self.respond_to? :qte
        errors.add(:qte, "is too big. Cant afford that much.")
      else
        errors.add(:base, "Cant afford.")
      end
    end
  end
  
  def can_buy?
    return buyer_accessible_stocks.can_subtract?(cost)
  end
  
  def buy
    buyer_accessible_stocks.subtract(cost) if bougth
  end
  
  def on_bougth
    self.ready = calcul_ready if bougth && readyable?
  end
  
  def is_ready
    ready.nil?
  end
  def is_ready_changed?
    ready_changed?
  end
  
  def calcul_ready
    Time.now + buy_time
  end
  
  def on_ready
    if readyable?
      self.ready = nil
      save!
    end
  end
  
  def cost
    costs = buyable_type.costs.multiply(self.respond_to?(:qte) ? qte : 1)
  end
  
  def readyable?
    self.respond_to?(:ready) && !buy_time.nil?
  end
  
  def buyable_type
    send(self.class.buyable_type)
  end
  
  def buyer
    send(self.class.buyer)
  end
  
  def buyer_accessible_stocks
    buyer.respond_to?(:accessible_stocks) ? buyer.accessible_stocks : buyer.stocks
  end
  
  def buy_time
    if buyable_type.respond_to?(:buy_time)
      buyable_type.buy_time 
    else
      nil
    end
  end
  
  module ClassMethods

    attr_accessor :buyable_type
    attr_accessor :buyer
    
    def buyable_types_for(stocks)
      stocks = stocks.to_a
      assoc = reflect_on_association(buyable_type)
      types = assoc.klass
      cond = []
      Ressource.all.each do |res|
        types = types.joins(
          'LEFT OUTER JOIN stocks as '+res.alias+' ON ' + 
            res.alias+'.stockable_id = '+assoc.table_name+'.id AND ' + 
            res.alias+'.stockable_type = "'+assoc.klass.model_name+'" AND ' + 
            res.alias+'.ressource_id = '+res.id.to_s
        )
        stock = stocks.select{ |s| s.ressource_id == res.id }.first
        if stock.nil?
          cond.push(res.alias+'.id IS NULL')
        else
          cond.push(res.alias+'.id IS NULL OR '+res.alias+'.qte <= '+stock.qte.to_s)
        end
      end
      types.where('('+cond.join(") AND (")+')')
    end
    
  end

end