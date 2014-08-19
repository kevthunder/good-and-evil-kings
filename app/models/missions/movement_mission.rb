class MovementMission < Mission

  class << self
    def allow_target(target,kingdom)
      target.class.model_name == Castle.model_name
    end
    
    def needs_field_garrisons
      true
    end
  end
  
end