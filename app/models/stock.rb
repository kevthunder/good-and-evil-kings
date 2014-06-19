class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  before_save :limit_qte
  
  
  def can_unite?(stock)
    ressource_id == stock.ressource_id
  end
  
  def max
    stockable.nil? ? nil : (stockable.respond_to?(:max_stock) ? stockable.max_stock(self) : nil)
  end
  
  def min
    0
  end
  
  def limit_qte
    unless qte.nil?
      self.qte = [qte,max].min unless max.nil?
      self.qte = [qte,min].max unless min.nil?
    end
    qte
  end
  
  def self.model_name
    return super if self == Mission
    Mission.model_name
  end
  
  def match_in(stocks)
    if(!stocks.respond_to?('where') || stocks.loaded?)
      stocks.select { |s| s.can_unite?(self) }.first
    else
      stocks.where(ressource_id: ressource_id).first
    end
  end
  
  def tranfer(stockable,number = true,match = nil, edit_self = true)
    number = (number === true ? qte : number)
    matched = match_in(match.nil? ? stockable.stocks : match)
    
    transaction do
      if !matched.nil?
        matched.qte += number
        matched.save!
      elsif !edit_self || number != qte
        get_normal_stocks.create qte: number, ressource_id: ressource_id
      end
      if edit_self
        if number != qte
          self.qte -= number
          save!
        else
          if matched.nil?
            self.stockable = stockable
            save!
          else
            destroy
          end
        end
      end
    end
  end
  
  def get_normal_stocks
    self.class.get_normal_stocks(stockable)
  end
  
  scope :match_stocks, (lambda do |stocks|
    stocks = [stocks] unless stocks.respond_to?('map')
    where ressource_id: stocks.map{ |s| s.ressource_id }
  end)
  
  scope :renderable, (lambda do 
    includes(:ressource)
  end)
  
  class << self
    def qte
      sum 'qte'
    end
    
    def give_any(stockable,number)
      stocks = all.to_a
      match = stockable.stocks.match_stocks(stocks).load
      total = stocks.sum { |s| s.qte }
      number = [number,total].min
      stocks.each do |s|
        qte = s.qte * number / total
        number -= qte
        total -= qte
        s.tranfer(stockable,qte,match)
      end
    end
    
    def get_normal_stocks(stockable)
      unscoped.where(stockable: stockable).where(type: nil) # for some reason stockable.stocks has where(type: :income)
    end
    
    include StockCollection
    
    
  end
end
