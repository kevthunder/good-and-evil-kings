class Mission < ActiveRecord::Base
  belongs_to :mission_type
  belongs_to :mission_status
  belongs_to :castle
	belongs_to :target, polymorphic: true
end
