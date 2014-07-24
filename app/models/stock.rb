class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  before_save :limit_qte
  
  include Quantifiable
  self.quantified = Ressource
  
  
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
    return super if self == Stock
    Stock.model_name
  end
  
  def match_in(stocks)
    if(!stocks.respond_to?('where') || stocks.loaded?)
      stocks.select { |s| s.can_unite?(self) }.first
    else
      stocks.where(ressource_id: ressource_id).first
    end
  end
  
  def to_i
    qte
  end
  
  def tranfer(stockable,number = true,match = nil, edit_self = true)
    Stock.unscoped do
      number = (number === true ? qte : number)
      matched = match_in(match.nil? ? stockable.stocks : match)
      
      transaction do
        if !matched.nil?
          matched.qte += number
          matched.save!
        elsif !edit_self || number != qte
          stockable.stocks_raw.create qte: number, ressource_id: ressource_id
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
  end
  
  scope :match_stocks, (lambda do |stocks|
    stocks = [stocks] unless stocks.respond_to?('map')
    where ressource_id: stocks.map{ |s| s.ressource_id }
  end)
  
  scope :renderable, (lambda do 
    includes(:ressource)
  end)
  
  class << self
    def give_any(stockable,number)
      stocks = all.to_a
      Stock.unscoped do
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
    end
    
    def add(number, ressource, stockable)
      if ressource.is_a?(String) || ressource.is_a?(Symbol)
        ressource_id = Ressource.find_by_name(ressource) 
      elsif ressource.respond_to?(:id)
        ressource_id = ressource.id
      else
        ressource_id = ressource
      end
      
      if ressource_id
        existing = find_by_ressource_id(ressource_id)
        if existing 
          existing.qte += number;
          existing.save
        else
          stockable.stocks_raw.create qte: number, ressource_id: ressource_id
        end
      end
    end
    
    Ressource.all.each do |r| 
      define_method(r.alias) do ||
        find_by_ressource_id(r.id)
      end
    end
    
    include StockCollection
    
    
  end
end
