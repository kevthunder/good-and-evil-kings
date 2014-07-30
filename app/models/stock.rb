class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  before_save :limit_qte
  
  include Quantifiable
  self.quantified = Ressource
  
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
  
  scope :renderable, (lambda do 
    includes(:ressource)
  end)
  
  class << self
    def add_qty(number, ressource, stockable)
      if ressource.is_a?(String) || ressource.is_a?(Symbol)
        ressource_id = Ressource.find_by_name(ressource).id
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
          stockable.stocks.create qte: number, ressource_id: ressource_id
        end
      end
    end
    
    Ressource.all.each do |r| 
      define_method(r.alias) do ||
        find_by_ressource_id(r.id)
      end
    end
    
  end
end
