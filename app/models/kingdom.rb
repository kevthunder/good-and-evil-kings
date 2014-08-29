class Kingdom < ActiveRecord::Base
  belongs_to :user
  has_many :castles
  has_many :stocks, -> { extending(Quantifiable::HasManyExtension) }, as: :stockable, inverse_of: :stockable
  has_many :ais, through: :castles
  
  def change_karma(power)
    max_karma = 10000
    return karma if power == 0 || (karma > max_karma && power > 0)  || (-karma > max_karma && power < 0)
    self.karma += (
      power > 0 ? 
        Math.sqrt(karma*-1+max_karma)/Math.sqrt(max_karma)*power
      : Math.sqrt(karma+max_karma)/Math.sqrt(max_karma)*power
    )
  end
  
  scope :ais_outer, (lambda do 
    joins('LEFT OUTER JOIN "castles" ON "castles"."kingdom_id" = "kingdoms"."id" LEFT OUTER JOIN "ais" ON "ais"."castle_id" = "castles"."id"')
  end)
  
  scope :ai_maxed, (lambda do 
    ais_outer.group("kingdoms.id").having("count(ais.id) >= kingdoms.max_ais")
  end)
  
  scope :not_ai_maxed, (lambda do 
    ais_outer.group("kingdoms.id").having("count(ais.id) < kingdoms.max_ais")
  end)
  
end
