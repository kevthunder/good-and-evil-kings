class Mission < ActiveRecord::Base
  belongs_to :mission_type
  belongs_to :mission_status
  belongs_to :castle
	belongs_to :target, polymorphic: true
  
  after_create :start_behavior
  

  def behavior
    if @behavior.blank?
      @behavior = false
      if self.mission_type && self.mission_type.behavior
        begin  
          cls = Object.const_get(self.mission_type.behavior + "MissionBehavior")
        rescue  
          fail 'MissionBehavior not Found'
        end 
        @behavior = cls.new(self)
      end
    end
    @behavior
  end
  
  private
    def startBehavior
      self.behavior.start
    end
end
