class Income < Stock
  before_save :must_be_applied
  
  def to_add_since since
    if since.nil?
      since = updated_at
    else
      since = max(since,updated_at)
    end
    from = (since - updated_at) / (3600/qty)
    to = (DateTime.now - updated_at) / (3600/qty)
    to - from
  end
  
  def must_be_applied
    stockable.incomes.apply
  end
  
  class << self
    def apply stockable
      if stockable.incomes_date.nil? || stockable.incomes_date + 1 < DateTime.now
        incomes = all.load
        if incomes.to_a.count > 0 # to_a because it's loaded
          stockable.incomes_date = DateTime.now
          match = stockable.stocks.match_stocks(incomes).load
          incomes.each do |income|
            add = income.to_add_since stockable.incomes_date
            income.tranfer(stockable,add,match,false)
          end
          stockable.incomes_date = DateTime.now
          stockable.save!
        end
      end
    end
  end
end
