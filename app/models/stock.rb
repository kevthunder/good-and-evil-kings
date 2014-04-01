class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
  
  
  def can_unite?(stock)
    ressource_id == stock.ressource_id
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
      match = stockable.stocks.match_garrisons(stocks).to_a
      total = stocks.sum { |s| s.qte }
      number = [number,total].min
      stocks.each do |s|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        qte = s.qte * number / total
        number -= qte
        total -= qte
        unless matched.nil?
          matched.qte += qte
          matched.save
        end
        if qte != s.qte
          if matched.nil?
            stockable.stocks.create qte: qte, ressource_id: s.ressource_id
          end
          s.qte -= qte
          s.save
        else
          if matched.nil?
            s.stockable = stockable
            s.save
          else
            s.destroy
          end
        end
      end
      reload
    end
  end
end
