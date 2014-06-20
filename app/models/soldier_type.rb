class SoldierType < ActiveRecord::Base
  has_many :costs, class_name: :Stock, as: :stockable
  has_many :modificators, as: :applier

  accepts_nested_attributes_for :costs, :modificators, allow_destroy: true
  
  
  alias_attribute :buy_time, :recrute_time
end
