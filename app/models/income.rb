class Income < Stock
  
  include Updated
  updated_column :breakpoint_time, :do_break
  
  before_save :must_be_applied
  
  alias_method :matching_max, :max
  
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
    if add != 0
      if matching.nil?
        stockable.stocks.add_qty(add,ressource)
      else
        matching.qte += add
        matching.save
      end
    end
  end
  
  def must_be_applied
    stockable.incomes.apply stockable
  end
  
  def matching
    @matching ||= match_in(stockable.stocks)
  end
  
  def on_matching_updated(stock)
    unless self.class.notices_ignored
      @matching = stock
      do_break
      check_breakpoints
    end
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
    breakpoint_time = full_break_time || zero_break_time || nil
    save if breakpoint_time != self.breakpoint_time_was
  end
  
  def full_break?
    !matching_max.nil? && qte > 0
  end
  
  def full_broke?
    full_break? && matching_qte >= matching_max
  end
  
  def full_break_time
    return nil unless full_break?
    Time.at((last_change.to_f + (matching_max - matching_qte) * sec_per_change).ceil);
  end
  
  def do_full_break
    return false unless full_broke?
    
    stockable.send(:on_stock_full,self) if stockable.respond_to?(:on_stock_full)
    true
  end
  
  def zero_break?
    qte < 0
  end
  
  def zero_broke?
    zero_break? && matching_qte <= 0
  end
  
  def zero_break_time
    return nil unless zero_break?
    
    Time.at((last_change.to_f + matching_qte * sec_per_change).ceil);
  end
  
  def do_zero_break
    return false unless zero_broke?
    
    stockable.send(:on_stock_empty,self) if stockable.respond_to?(:on_stock_empty)
    true
  end
  
  def do_break
    Stock.unscoped do
      do_zero_break
      do_full_break
    end
  end
  
  class << self
    attr_accessor :notices_ignored
    def ignore_notices()
      tmp = self.notices_ignored
      self.notices_ignored = true
      yield
      self.notices_ignored = tmp
    end
  
  
    def apply(stockable = nil)
      ignore_notices do 
        each_stockable(stockable) do |stockable,incomes|
          if incomes.apply_interval(stockable.incomes_date,DateTime.now, stockable)
            Stock.unscoped do
              stockable.incomes_date = DateTime.now
              stockable.save!
            end
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
          match = stockable.stocks_raw.where(type: nil).match(incomes).load unless stockable.nil?
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
