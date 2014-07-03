class TaxMission < Mission

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