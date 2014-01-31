class Action < ActiveRecord::Base
  belongs_to :actionnable, polymorphic: true
end
