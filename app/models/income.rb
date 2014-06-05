class Income < Stock
  before_save :must_be_applied
  
  def to_add_since since
    debugger
    return 0 unless qte != 0
    if since.nil?
      since = updated_at
    else
      since = [since,updated_at].max
    end
    from = (since.to_f  - updated_at.to_f ) / (3600/qte)
    to = (DateTime.now.to_f - updated_at.to_f) / (3600/qte)
    to.to_i - from.to_i
  end
  
  def must_be_applied
    stockable.incomes.apply stockable
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
            income.tranfer(stockable,add,match,false) if add != 0
          end
          stockable.incomes_date = DateTime.now
          stockable.save!
        end
      end
    end
  end
end
