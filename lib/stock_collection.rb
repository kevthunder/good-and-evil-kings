module StockCollection
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
end