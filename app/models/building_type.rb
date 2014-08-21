class BuildingType < ActiveRecord::Base
  has_many :costs, ->{ extending Quantifiable::HasManyExtension }, class_name: :Stock, as: :stockable
  has_many :modificators, as: :applier
  
  has_many :upgrades, class_name: "BuildingType",
                          foreign_key: "predecessor_id"
 
  belongs_to :predecessor, class_name: "BuildingType"

  accepts_nested_attributes_for :costs, :modificators, allow_destroy: true
  
  include Randomizable
  
  def self.model_name
    return super if self == BuildingType
    BuildingType.model_name
  end
  
  scope :basic, (lambda do 
    where(:predecessor_id => nil)
  end)
  
  class << self
  
  end
end
