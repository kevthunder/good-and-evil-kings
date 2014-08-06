class Kingdom < ActiveRecord::Base
  belongs_to :user
  has_many :stocks, -> { extending(Quantifiable::HasManyExtension) }, as: :stockable, inverse_of: :stockable
  
  def change_karma(power)
    max_karma = 10000
    return karma if power == 0 || (karma > max_karma && power > 0)  || (-karma > max_karma && power < 0)
    self.karma += (
      power > 0
      ? Math.sqrt(karma*-1+max_karma)/Math.sqrt(max_karma)*power
      : Math.sqrt(karma+max_karma)/Math.sqrt(max_karma)*power
    )
  end
end
