class BuildingType < ActiveRecord::Base
  has_many :costs, ->{ extending Quantifiable::HasManyExtension }, class_name: :Stock, as: :stockable
  has_many :modificators, as: :applier
  
  has_many :upgrades, class_name: "BuildingType",
                          foreign_key: "predecessor_id"
 
  belongs_to :predecessor, class_name: "BuildingType"
  belongs_to :base, class_name: "BuildingType"

  accepts_nested_attributes_for :costs, :modificators, allow_destroy: true
  
  before_save :update_base 
  
  include Randomizable
  extend InheritenceBaseNaming
  
  def alias
    name.parameterize('_')
  end
  
  scope :basic, (lambda do 
    where(:predecessor_id => nil)
  end)
  
  def update_base
    unless predecessor_id.nil?
      self.base_id = predecessor.base_id || predecessor.id 
      self.max_instances = nil
    end
  end
  
  def max_instances
    return base.max_instances unless base.nil?
    super
  end
  
  class << self
  
  end
end
