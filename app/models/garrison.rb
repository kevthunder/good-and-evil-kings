# Encoding: utf-8

# A group Of soldier of the same type
class Garrison < ActiveRecord::Base
  belongs_to :kingdom
  belongs_to :soldier_type
  belongs_to :garrisonable, polymorphic: true
 
  include Buyable
  alias_attribute :recruted, :bougth
  alias_method :buyer, :garrisonable
  alias_method :buyable_type, :soldier_type
  
  include ModApplier
  apply_mods_to :garrisonable, provider: :soldier_type, direct: false

  def can_unite?(garrison)
    soldier_type_id == garrison.soldier_type_id && kingdom_id == garrison.kingdom_id
  end
  
  def add_to(garrison)
    garrison.qte += qte
    garrison.save!
    destroy!
  end
  
  def alter_mod(mod)
    mod.num *= qte
    mod
  end
  
  def merge
    match = garrisonable.garrisons.ready.match_garrisons self
    matched = match.count > 1
    if matched
      add_to(matched.first);
    end
    matched
  end
  
  def on_ready
    unless merge
      ready = null
      save!
    end
  end
  
  scope :match_garrisons, (lambda do |garrisons|
    garrisons = [garrisons] unless garrisons.respond_to?('each')

    or_conds = Array.new
    replace = {}
    i = 0
    garrisons.each do |garrison|
      or_conds.push "(soldier_type_id = :soldier_type_id#{i}" \
        ' AND kingdom_id ' + (garrison.kingdom_id.nil? ? 'IS NULL' : "= :kingdom_id#{i}") + ')'
      replace[:"soldier_type_id#{i}"] = garrison.soldier_type_id
      replace[:"kingdom_id#{i}"] = garrison.kingdom_id
      i += 1
    end

    where(or_conds.join(' OR '), replace)
  end)
  
  scope :renderable, (lambda do 
    includes(:soldier_type)
  end)

  class << self
    def qte
      sum 'qte'
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

    include GarrisonCollection
    
    def attack_cost(garrisonable)
      att_data = get_battle_data('attack')
      total_att = att_data.sum { |d| d[:power] }
      def_data = garrisonable.garrisons.ready.get_battle_data('defence')
      total_def = def_data.sum { |d| d[:power] }
      cost = [total_att,total_def,[total_att,total_def].sum * 3 / 8].min
      att_casualties = att_data.map do |d| 
        Garrison.new(qte: d[:qte] * cost / total_att, soldier_type_id: d[:type]) 
      end
      def_casualties = def_data.map do |d| 
        Garrison.new(qte: d[:qte] * cost / total_def, soldier_type_id: d[:type]) 
      end
      #ratio = att.map{ |d| d[:power].to_f/t_power * t_qte/d[:qte].to_f }
      { us: GarrisonList.new(att_casualties), them: GarrisonList.new(def_casualties) }
    end


    def check_disponibility?(garrisons)
      garrisons = [garrisons] unless garrisons.respond_to?('each')

      garrisons = garrisons.to_a
      match = ready.match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        return false if matched.nil? || matched.qte < garrison.qte
      end
      true
    end

    def calcul_travel_time(pos1, pos2, speed)
      ((pos1.distance(pos2) / speed + 10) * 64).to_i
    end
    
    def get_upkeep_equiv(income)
      consumers = joins(soldier_type: :modificators).ready.where(
        'modificators.prop = :prop AND modificators.num < 0', 
        { :prop => 'income:'+income.ressource_id.to_s }
      )
      consumptions = consumers.pluck('garrisons.id, modificators.num, modificators.num * garrisons.qte').to_a
      total = consumptions.sum{ |r| -r[2].to_i }
      number = -income.qte
      taken = consumers.map do |consumer|
        per_unit = consumptions.first{ |r| r[0].to_i == consumer.id }[1] * -1
        qte = (consumer.qte * per_unit * number / total / per_unit).ceil
        number -= (consumer.qte - qte) * per_unit
        total -= (consumer.qte - qte) * per_unit
        Garrison.new(qte: qte, soldier_type_id: consumer.soldier_type_id) 
      end
      GarrisonList.new(taken);
    end
    
    def kill
      each do |garrison|
        garrison.destroy
      end
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
