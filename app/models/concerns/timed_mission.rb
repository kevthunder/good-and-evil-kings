module TimedMission
  extend ActiveSupport::Concern
  
  included do
    has_one :mission_length, as: :target
  end
  
  
  def mission_length_origin
    mission_length.nil? ? nil : mission_type.mission_lengths.find_by_seconds(mission_length.seconds)
  end
  def mission_length_origin_id 
    mission_length_origin = self.mission_length_origin
    mission_length_origin.nil? ? nil : mission_length_origin.id
  end
  def mission_length_origin_id= val
    mission_length_origin = mission_type.mission_lengths.find(val)
    mission_length = self.mission_length
    mission_length = MissionLength.new if mission_length.nil?
    mission_length.seconds = mission_length_origin.seconds
    mission_length.reward = mission_length_origin.reward
    self.mission_length = mission_length
    mission_length.save unless new_record?
  end
  
  def length 
    mission_length = self.mission_length
    raise "No length is attached to this Mission (ID: "+id.to_s+")" if !allow_nil_length? && mission_length.nil? 
    mission_length.seconds.second 
  end
  
  def allow_nil_length?
    false
  end
  
  def remaining 
    (next_event.nil? ? 0 : (next_event - Time.now).second / length) * 0.9 + 0.10
  end
  
  def reward_prc(remaining = 1)
    mission_length.reward * remaining / 820.0
  end
  
  module ClassMethods
    def needs_field_mission_length_origin_id
      true
    end
    
    def opt_length_read_val(opt)
      return TimeAmount.new(opt.val.to_i).pretty
    end
  end
end