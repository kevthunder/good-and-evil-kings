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
  
  def generate_name!
    self.name = Kingdom.generate_name
  end
  
  def new_inital_neighbours
    sizes = [1,2,4,6,10]
    first_castle = castles.first
    sizes.map{ |size| Ai.new_scattered(first_castle,size) }
  end
  
  def create_inital_neighbours
    new_inital_neighbours.each{ |n| n.save! }
  end
  
  class << self
    
    def new_auto_named(vals)
      vals[:name] = generate_name
      new(vals)
    end
    
    def available_or_create_for_size(side_size)
      available = where(max_ais: side_size).not_ai_maxed.first
      if available.nil?
        available = new_auto_named(max_ais: side_size)
      end
      available
    end
    
    def generate_name
      NameFragment.generate_until(:kingdom) { |name|
        Kingdom.where(name: name).count == 0
      }.humanize
    end
    
  end
  
end
