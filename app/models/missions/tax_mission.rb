class TaxMission < Mission

  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom == kingdom
    end
  end
  
end