class SoldierType < ActiveRecord::Base
  has_many :costs, class_name: :Stock, as: :stockable
  
  accepts_nested_attributes_for :costs, allow_destroy: true
end
