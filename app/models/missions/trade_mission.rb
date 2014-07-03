class TradeMission < Mission

  class << self
    def needs_field_stocks
      true
    end
  end
    
end