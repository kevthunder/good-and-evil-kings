class Kingdom < ActiveRecord::Base
  belongs_to :user
  has_many :stocks, -> { extending(Quantifiable::HasManyExtension) }, as: :stockable, inverse_of: :stockable
end
