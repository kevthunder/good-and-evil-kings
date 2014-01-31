class Stock < ActiveRecord::Base
  belongs_to :ressource
  belongs_to :stockable, polymorphic: true
end
