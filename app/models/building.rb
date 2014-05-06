class Building < ActiveRecord::Base
  belongs_to :building_type
  belongs_to :castle
end
