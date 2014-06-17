class Income < Stock
  Updater.add_updated self
  
  before_save :must_be_applied
  
  def to_add_since since
    return 0 unless qte != 0
    if since.nil?
      since = updated_at
    else
      since = [since,updated_at].max
    end
    from = (since.to_f  - updated_at.to_f ) / sec_per_change
    to = (DateTime.now.to_f - updated_at.to_f) / sec_per_change
    to.to_i - from.to_i
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
        income.do_break
      end
    end
    
    def apply(stockable)
      if stockable.incomes_date.nil? || stockable.incomes_date + 1 < DateTime.now
        incomes = all.load
        if incomes.to_a.count > 0 # to_a because it's loaded
          match = get_appliable_stocks(stockable).match_stocks(incomes).load
          incomes.each do |income|
            add = income.to_add_since stockable.incomes_date
            income.tranfer(stockable,add,match,false) if add != 0
          end
          stockable.incomes_date = DateTime.now
          stockable.save!
        end
      end
    end
    
    def get_appliable_stocks(stockable)
      stockable.stocks_raw.unscope(where: :type).where(type: nil) # for some reason stockable.stocks has where(type: :income)
    end
  end
end
