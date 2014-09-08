class Diplomacy < ActiveRecord::Base
  belongs_to :from_kingdom, class_name: :Kingdom
  belongs_to :to_kingdom, class_name: :Kingdom
  
  def change(power)
    max_karma = 10000
    return karma if power == 0 || (karma > max_karma && power > 0)  || (-karma > max_karma && power < 0)
    self.karma += (
      power > 0 ? 
        Math.sqrt(karma*-1+max_karma)/Math.sqrt(max_karma)*power
      : Math.sqrt(karma+max_karma)/Math.sqrt(max_karma)*power
    )
    last_interaction = Time.now
  end
  
  scope :from_kingdom, (lambda do |kingdom|
      id = Kingdom.id_from(kingdom)
      raise "Nothing to find" if id.nil?
      where(from_kingdom_id: id)
  end)
  scope :to_kingdom, (lambda do |kingdom|
      id = Kingdom.id_from(kingdom)
      raise "Nothing to find" if id.nil?
      where(to_kingdom_id: id)
  end)
  scope :order_by_strength, (lambda do
      order("#{table_name}.karma / (10 + julianday('#{Time.now}') - julianday(#{table_name}.last_interaction))")
  end)
    
  class << self
  
    def find_by_from_kingdom(kingdom)
      from_kingdom(kingdom).first
    end
    def find_by_to_kingdom(kingdom)
      to_kingdom(kingdom).first
    end
    def new_for(from,to)
      max_by_kindom = 20
      existing = Diplomacy.unscoped.from_kingdom(from)
      if existing.count > max_by_kindom
        existing.order_by_strength.last.destroy
      end
      new(from_kingdom_id: Kingdom.id_from(from),to_kingdom_id: Kingdom.id_from(to))
    end
  end
end
