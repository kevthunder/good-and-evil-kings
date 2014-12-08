class MissionType < ActiveRecord::Base
  has_many :options, as: :target
  has_many :mission_lengths, as: :target
  accepts_nested_attributes_for :options, :mission_lengths, allow_destroy: true
  
  def klass()
    Object.const_get(class_name)
  end

  def allow_target(target,kingdom)
    return false unless any_usable_castle_for_target?(target,kingdom)
    return klass.allow_target(target,kingdom) if klass.respond_to?(:allow_target)
    true
  end
  
  def any_usable_castle_for_target?(target,kingdom)
    return any_different_castle_from_target?(target,kingdom) unless klass.allow_same_target_and_castle?
    true
  end
  
  def any_different_castle_from_target?(target,kingdom)
    target.nil? || target.class.model_name != Castle.model_name || kingdom.castles.where.not(id: target.id).any?
  end
  
  def needs_field(field_name)
    klass.needs_field(field_name)
  end
  
  def opt_read_val(opt)
    klass.opt_read_val(opt)
  end

  class << self
    def allowing_target(target,kingdom)
      all.select do |mission_type|
        MissionType.unscoped do
          mission_type.allow_target(target, kingdom)
        end
      end
    end
  end
end
