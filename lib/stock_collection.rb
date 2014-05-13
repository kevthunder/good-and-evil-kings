module StockCollection
    def can_subtract_from?(stockable)
      if respond_to? :all
        stocks = all.load
      else
        stocks = to_a
      end
      match = stockable.stocks.ready.match_stocks(stocks).to_a

      stocks.each do |stock|
        matched = match.select { |g| g.can_unite?(stock) }.first
        return false if matched.nil? || matched.qte < stock.qte
      end
      true
    end
    
    def subtract_from(stockable)
      if respond_to? :all
        stocks = all.load
      else
        stocks = to_a
      end
      match = stockable.stocks.ready.match_stocks(stocks).to_a

      stocks.each do |stock|
        matched = match.select { |g| g.can_unite?(stock) }.first
        return false if matched.nil? || matched.qte < stock.qte
        if matched.qte == stock.qte
          matched.destroy
        else
          matched.qte -= stock.qte
          matched.save
        end
      end
      true
    end
    
    def add_to(stockable)
      if respond_to? :all
        stocks = all.load
      else
        stocks = to_a
      end
      match = stockable.stocks.match_stocks(stocks).load

      stocks.each do |s|
        s.tranfer(stockable,true,match)
      end
    end
    
    def multiply(num)
      StockList.new(map do |stock|
        Stock.new(qte: stock.qte*num, ressource_id: stock.ressource_id)
      end)
    end
end