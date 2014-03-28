# Encoding: utf-8

# A group Of soldier of the same type
class Garrison < ActiveRecord::Base
  belongs_to :kingdom
  belongs_to :soldier_type
  belongs_to :garrisonable, polymorphic: true

  def can_unite?(garrison)
    soldier_type_id == garrison.soldier_type_id && kingdom_id == garrison.kingdom_id
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

    def travel_time_between(pos1, pos2)
      Garrison.calcul_travel_time(pos1, pos2, speed)
    end

    def subtract_from(garrisonable)
      garrisons = to_a
      match = garrisonable.garrisons.match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        return false if matched.nil? || matched.qte < garrison.qte
        if matched.qte == garrison.qte
          matched.destroy
        else
          matched.qte -= garrison.qte
          matched.save
        end
      end
      true
    end

    def attack_cost(garrisonable)
      att_data = get_battle_data('attack')
      total_att = att_data.sum { |d| d[:power] }
      def_data = garrisonable.garrisons.get_battle_data('defence')
      total_def = def_data.sum { |d| d[:power] }
      cost = [total_att,total_def,[total_att,total_def].sum * 3 / 8].min
      att_casualties = att_data.map { |d| d[:qte] * cost / total_att }
      def_casualties = def_data.map { |d| d[:qte] * cost / total_def }
      #ratio = att.map{ |d| d[:power].to_f/t_power * t_qte/d[:qte].to_f }
      { us: att_casualties, them: def_casualties }
    end

    def add_to(garrisonable)
      garrisons = to_a
      match = garrisonable.garrisons.match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        if matched.nil?
          garrison.garrisonable = garrisonable
          garrison.save
        else
          matched.qte += garrison.qte
          matched.save
          garrison.destroy
        end
      end
    end

    def check_disponibility?(garrisons)
      garrisons = [garrisons] unless garrisons.respond_to?('each')

      garrisons = garrisons.to_a
      match = match_garrisons(garrisons).to_a

      garrisons.each do |garrison|
        matched = match.select { |g| g.can_unite?(garrison) }.first
        return false if matched.nil? || matched.qte < garrison.qte
      end
      true
    end

    def calcul_travel_time(pos1, pos2, speed)
      ((pos1.distance(pos2) / speed + 10) * 64).to_i
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
      .pluck("SUM(soldier_types.#{type} * qte),qte")
      .map { |d| { power: d[0], qte: d[1] } }
  end
end
