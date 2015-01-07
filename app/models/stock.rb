class Stock < ActiveRecord::Base
  class Collection < Quantifiable::Collection
    
    def globals
      model.new_collection(self.select{ |s| s.ressource.global })
    end
    
    def locals
      model.new_collection(self.reject{ |s| s.ressource.global })
    end
    
    def to_h
      hash = {}
      each do |g| 
        key = g.ressource.alias.to_sym
        hash[key] = (hash[key] || 0) + g.qte 
      end
      hash
    end
  end
  
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  before_save :limit_qte
  after_save :notify_stockable
  
  include Quantifiable
  self.quantified = Ressource
  
  extend InheritenceBaseNaming
  
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
  
  def notify_stockable
    stockable.on_stock_change(self) if stockable.respond_to?(:on_stock_change) && qte_changed?
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
  
  scope :globals, (lambda do 
    joins(:ressource).merge(Ressource.where(:global => true))
  end)
  
  scope :locals, (lambda do 
    joins(:ressource).merge(Ressource.where(:global => false))
  end)
  
  class << self
    def collection_type
      Stock::Collection
    end
    
    
    Ressource.all.each do |r| 
      define_method(r.alias) do ||
        find_by_ressource_id(r.id)
      end
    end
    
    def to_h
      Hash[joins(:ressource).pluck("ressources.name",:qte).map{ |pair| [pair[0].parameterize('_').to_sym,pair[1]] }]
    end
  end
end
