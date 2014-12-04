# Encoding: utf-8

# A group Of soldier of the same type
class Garrison < ActiveRecord::Base
  class Collection < Quantifiable::Collection
    def carry
      inject(0){|sum,g| sum + g.soldier_type.carry }
    end
    
    def to_h
      hash = {}
      each do |g| 
        key = g.soldier_type.alias.to_sym
        hash[key] = (hash[key] || 0) + g.qte 
      end
      hash
    end
  end
  module HasManyExtension
    include Quantifiable::HasManyExtension
    
    
    SoldierType.unscoped.each do |s| 
      define_method(s.alias.pluralize) do ||
        return to_collection.select{ |g| g.soldier_type_id == s.id } if proxy_association.owner.new_record?
        super()
      end
    end
    
    def set_kingdom(kingdom_id)
      kingdom_id = kingdom_id.id if kingdom_id.respond_to?(:id)
      return to_collection.map{ |g| g.kingdom_id = kingdom_id }.count if proxy_association.owner.new_record?
      super
    end
    
    def speed
      return SoldierType.where(id: to_a.map{ |g| g.soldier_type_id}).minimum('speed') if proxy_association.owner.new_record?
      super
    end
    
    def travel_time_between(pos1, pos2)
      Garrison.calcul_travel_time(pos1, pos2, speed)
    end
  end
  validate :check_recruitable_qty
  
  belongs_to :kingdom
  belongs_to :soldier_type
  belongs_to :garrisonable, polymorphic: true
 
  include Quantifiable
  self.quantified = SoldierType
  
  include Buyable
  alias_attribute :recruted, :bougth
  self.buyer = :garrisonable
  self.buyable_type = :soldier_type
  
  include ModApplier
  apply_mods_to :garrisonable, provider: :soldier_type, direct: false, switch: :is_ready

  def can_unite?(garrison)
    soldier_type_id == garrison.soldier_type_id && (kingdom_id.nil? || garrison.kingdom_id.nil? || kingdom_id == garrison.kingdom_id)
  end
  
  def add_to(garrison)
    garrison.qte += qte
    garrison.save!
    destroy!
  end
  
  def check_recruitable_qty()
    if bougth && !enough_recruitable_qty?
      errors.add(:qte, " cant recrute this much simultaneously.")
    end
  end
  
  def enough_recruitable_qty?
    remaining_recruitable_qty >= qte
  end
  
  
  def apply_mods_state_changed?(opt)
    return true if qte_changed?
    super(opt)
  end
  
  def alter_mod(mod)
    mod.num *= qte
    mod
  end
  
  def merge
    if ready.nil?
      match = garrisonable.garrisons.ready.match(self)
      matched = match.count > 0
      if matched
        add_to(match.first);
      end
      matched
    end
  end
  
  def on_ready
    self.ready = nil
    unless merge
      save!
    end
  end
  
  scope :_match, (lambda do |garrisons|
    garrisons = Garrison.new_collection(garrisons)

    or_conds = Array.new
    replace = {}
    i = 0
    garrisons.each do |garrison|
      or_conds.push "(soldier_type_id = :soldier_type_id#{i}" + 
        (garrison.kingdom_id.nil? ? '' : " AND (kingdom_id = :kingdom_id#{i} OR kingdom_id IS NULL)") + 
        (garrison.id.nil? ? '' : " AND id <> :not_id#{i}") + 
      ')'
      replace[:"soldier_type_id#{i}"] = garrison.soldier_type_id
      replace[:"kingdom_id#{i}"] = garrison.kingdom_id unless garrison.kingdom_id.nil?
      replace[:"not_id#{i}"] = garrison.id unless garrison.id.nil?
      i += 1
    end

    where(or_conds.join(' OR '), replace)
  end)
  
  scope :military, (lambda do 
    joins(:soldier_type).merge(SoldierType.where(:military => true))
  end)
  
  scope :civil, (lambda do 
    joins(:soldier_type).merge(SoldierType.where(:military => false))
  end)
  
  scope :renderable, (lambda do 
    includes(:soldier_type)
  end)
  
  SoldierType.unscoped.each do |s| 
    scope s.alias.pluralize.to_sym, (lambda do 
      where(:soldier_type_id => s.id)
    end)
  end

  class << self
    def collection_type
      Garrison::Collection
    end
    
    def speed
      joins(:soldier_type).minimum('soldier_types.speed')
    end

    def attack
      joins(:soldier_type).sum('soldier_types.attack * qte')
    end

    def defence
      joins(:soldier_type).sum('soldier_types.defence * qte')
    end

    def interception
      joins(:soldier_type).sum('soldier_types.interception * qte')
    end
    
    def carry
      joins(:soldier_type).sum('soldier_types.carry * qte')
    end

    def travel_time_between(pos1, pos2)
      Garrison.calcul_travel_time(pos1, pos2, speed)
    end

    def check_disponibility?(garrisons)
      ready.can_subtract?(garrisons)
    end

    def calcul_travel_time(pos1, pos2, speed)
      ((pos1.distance(pos2) / speed + 10) * 64).to_i
    end
    
    def get_upkeep_equiv(income)
      return new_collection() unless income.qte < 0
      consumers = joins(soldier_type: :modificators).ready.where(
        'modificators.prop = :prop AND modificators.num < 0', 
        { :prop => 'income:'+income.ressource_id.to_s }
      )
      consumptions = consumers.pluck('garrisons.id, modificators.num, modificators.num * garrisons.qte').to_a
      total = consumptions.sum{ |r| -r[2].to_i }
      number = -income.qte
      taken = consumers.map do |consumer|
        qte = 0
        if total > 0
          per_unit = consumptions.first{ |r| r[0].to_i == consumer.id }[1] * -1
          qte = (consumer.qte * per_unit * number / total / per_unit).ceil
          number -= (consumer.qte - qte) * per_unit
          total -= (consumer.qte - qte) * per_unit
        end
        Garrison.new(qte: qte, soldier_type_id: consumer.soldier_type_id) 
      end
      new_collection(taken);
    end
    
    def kill
      each do |garrison|
        garrison.destroy
      end
    end
    
    
    def set_kingdom(kingdom_id)
      kingdom_id = kingdom_id.id if kingdom_id.respond_to?(:id)
      update_all(kingdom_id: kingdom_id)
    end
    
    def to_h
      Hash[joins(:soldier_type).pluck("soldier_types.alias",:qte).map{ |pair| [pair[0].to_sym,pair[1]] }]
    end
    
  end

  #private

  def self.get_battle_data(type)
    joins(:soldier_type)
      .group('soldier_type_id')
      .pluck("SUM(soldier_types.#{type} * qte),qte,soldier_type_id")
      .map { |d| {type: d[2], power: d[0], qte: d[1] } }
  end
end
