class AttackMission < Mission

  validate :must_have_one_garrison
  
  def initialize
    @startStatus = "going"
  end
  
end