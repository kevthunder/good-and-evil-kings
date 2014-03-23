class AttackMission < Mission

  validate :must_have_one_garrison, on: :create
  validate :garrisons_must_be_available, on: :create
  
  def initialize(id)
    @startStatus = "going"
    super
  end
  
  private
    def unsaved_garrisons
      garrisons.loaded? && garrisons.count == 0 && garrisons.size > 0
    end
    def calcul_travel_time
      return garrisons.travel_time_between(castle,target) unless unsaved_garrisons
      Garrison.calcul_travel_time(castle,target,SoldierType.where(:id => garrisons.collect {|g| g.soldier_type_id}).minimum("speed"))
    end
    def start
      super
      self.next_event = Time.now + calcul_travel_time
    end
end