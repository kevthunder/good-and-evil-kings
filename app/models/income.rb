class Income < Stock
  Updater.add_updated self
  
  before_save :must_be_applied
  
  def max
    nil
  end
  
  def min
    nil
  end
  
  def to_add_interval(from, to)
    return 0 unless qte != 0
    if from.nil?
      from = updated_at
    else
      from = [from,updated_at].max
    end
    rfrom = (from.to_f  - updated_at.to_f ) / sec_per_change
    rto = (to.to_f - updated_at.to_f) / sec_per_change
    rto.to_i - rfrom.to_i
  end
  
  def apply_interval(from, to, match = nil)
    add = to_add_interval(from, to)
    tranfer(stockable,add,match,false) if add != 0
  end
  
  def must_be_applied
    stockable.incomes.apply stockable
  end
  
  def matching
    match_in(Income.get_appliable_stocks(stockable))
  end
  
  def matching_qte
    m = matching
    m ? m.qte : 0
  end
  
  def sec_per_change
    return 3600.0 / qte
  end
  def last_change
    ((DateTime.now.to_f - updated_at.to_f) / sec_per_change).floor * sec_per_change + updated_at.to_f
  end
  
  def check_breakpoints
    if calcul_full_break
    elsif calcul_zero_break
    else
      breakpoint_time = nil
    end
  end
  
  def full_break?
    qte > 0
  end
  
  def calcul_full_break
    return false unless full_break?
    
    #breakpoint_time = Time.at((last_change.to_f + (max - matching_qte) * sec_per_change).ceil);
    
    breakpoint_time = nil
    
    true
  end
  
  def do_full_break
    return false unless zero_break?
    
    stockable.send(:on_stock_full,self) if stockable.respond_to?(:on_stock_full)
    true
  end
  
  def zero_break?
    qte < 0
  end
  
  def calcul_zero_break
    return false unless zero_break?
    breakpoint_time = Time.at((last_change.to_f + matching_qte * sec_per_change).ceil);
    stockable.send(:on_stock_empty,self) if stockable.respond_to?(:on_stock_empty)
    true
  end
  
  def do_zero_break
    return false unless zero_break?
    
    true
  end
  
  def do_break
    do_zero_break
    do_full_break
  end
  
  
  scope :to_update, -> { where('breakpoint_time < ?', Time.now) }
  
  class << self
  
    def update
      to_update.each do |income|
        Stock.unscoped do
          income.do_break
        end
      end
    end
    
    def apply(stockable = nil)
      each_stockable(stockable) do |stockable,incomes|
        if incomes.apply_interval(stockable.incomes_date,DateTime.now, stockable)
          Stock.unscoped do
            stockable.incomes_date = DateTime.now
            stockable.save!
          end
        end
      end
    end
    
    def simulate(time, stockable = nil)
      each_stockable(stockable) do |stockable,incomes|
        incomes.apply_interval(DateTime.now, DateTime.now+time, stockable)
      end
    end
    
    def each_stockable(stockable = nil)
      if stockable.nil?
        all.includes(:stockable).group(:stockable_id,:stockable_id).each do |i|
          yield i.stockable, where(stockable: i.stockable)
        end
      else
        yield stockable, all
      end
    end
    
    def test
      debugger
      test = 123
    end
    
    #private 
    
    def apply_interval(from, to, stockable = nil)
      incomes = all.load
      Stock.unscoped do
        if incomes.to_a.count > 0 # to_a because it's loaded
          match = nil
          match = stockable.stocks_raw.where(type: nil).match_stocks(incomes).load unless stockable.nil?
          incomes.each do |income|
            #income.stockable = stockable unless stockable.nil?
            income.apply_interval(from, to, match)
          end
          true
        end
      end
    end
    
  end
end
