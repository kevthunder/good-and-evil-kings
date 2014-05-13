class Building < ActiveRecord::Base
  belongs_to :building_type
  belongs_to :castle
  
  include Buyable
  alias_method :buyer, :castle
  alias_method :buyable_type, :building_type
end
