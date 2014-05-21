class BuildingType < ActiveRecord::Base
  has_many :costs, class_name: :Stock, as: :stockable
  has_many :modificators, as: :applier

  accepts_nested_attributes_for :costs, :modificators, allow_destroy: true
  
  def self.model_name
    return super if self == BuildingType
    BuildingType.model_name
  end
end
