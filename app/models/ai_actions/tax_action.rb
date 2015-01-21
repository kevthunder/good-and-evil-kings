class TaxAction < AiAction
  def executable_for(ai)
    !ai.castle.missions.where(type:'TaxMission').ongoing.any?
  end
  
  
  def execute_for(ai)
    mission = TaxMission.create!( castle: ai.castle , target:ai.castle, mission_length_origin_id: self.class.mission_length_id)
  end
  
  class << self
    def mission_length_id
      @mission_length_id ||= mission_lengths.where('seconds <= ?',12.hours).order('seconds desc').limit(1).pluck(:id).first
    end
    def mission_lengths
      MissionLength.joins_target_type(MissionType).merge(MissionType.where(class_name:'TaxMission'))
    end
  end
end