class TaxMission < Mission

  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['collecting','waiting'])
  end
  
  def length 
    unsaved = options.select{ |o| o.name == "length"}
    (unsaved.length > 0 ? unsaved.first : options.find_by_name(:length) ).val.to_i.second
  end
  
  def start
    self.castle = target
    self.next_event = Time.now + length
    super
  end
  
  def redeem
    target.stocks.add((target.pop * (length / 900) ** 0.75).to_i ,:coins,target)
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom == kingdom
    end
    
    def needs_field_castle_id
      false
    end
    
    def opt_length_read_val(opt)
      return TimeAmount.new(opt.val.to_i).pretty
    end
  end
  
end