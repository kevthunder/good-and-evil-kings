class Income < Stock
  
  def to_add_since since
    from = (since - updated_at) / (3600/qty)
    to = (DateTime.now - updated_at) / (3600/qty)
    to - from
  end
  
  class << self
    def apply stockable
        incomes = all.load
        match = stockable.stocks.match_stocks(incomes).load
        incomes.each do |income|
          add = income.to_add_since stockable.incomes_date
          income.tranfer(stockable,add,match,false)
        end
        stockable.incomes_date = DateTime.now
      end
    end
  end
end
