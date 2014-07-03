class MissionType < ActiveRecord::Base
  has_many :options, as: :target
  accepts_nested_attributes_for :options, allow_destroy: true
  
  def klass()
    Object.const_get(class_name)
  end

  def allow_target(target,kingdom)
    return klass.allow_target(target,kingdom) if klass.respond_to?(:allow_target)
    true
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
