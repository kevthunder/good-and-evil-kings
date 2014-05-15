class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  
  def can_unite?(stock)
    ressource_id == stock.ressource_id
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
      unless matched.nil?
        matched.qte += number
        matched.save
      else if !edit_self || number != qte
        stockable.stocks.create qte: number, ressource_id: ressource_id
      end
      if edit_self
        if number != qte
          self.qte -= number
          save
        else
          if matched.nil?
            self.stockable = stockable
            save
          else
            destroy
          end
        end
      end
    end
  end
  
  scope :match_stocks, (lambda do |stocks|
    stocks = [stocks] unless stocks.respond_to?('map')
    where ressource_id: stocks.map{ |s| s.ressource_id }
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
    
    include StockCollection
    
    
  end
end
