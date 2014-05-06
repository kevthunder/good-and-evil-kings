class BuildingType < ActiveRecord::Base

  def self.model_name
    return super if self == BuildingType
    BuildingType.model_name
  end
end
