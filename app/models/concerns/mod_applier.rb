module ModApplier
  extend ActiveSupport::Concern

  included do
    has_many :modificators_direct, class_name: :Modificator, :as => :applier
    has_many :modifications, :as => :applier, dependent: :destroy
    has_many :modificators_indirect, :through => :modifications
    
    after_create :apply_mods_on_create
    after_save :update_mods
  end

  def modificators 
    Modificator.joins(:modifications).where('(modifications.applier_type = :type AND modifications.applier_id = :id)' \
                                      + ' OR (modificators.applier_type = :type AND modificators.applier_id = :id)',
                                      {type: self.class.model_name.to_s, id: id}
                                   )
  end
  
  def apply_mods?(opt)
    return send(opt[:switch]) unless opt[:switch].nil?
    true
  end
  
  def apply_mods_state_changed?(opt)
    return true if send(opt[:prop]+"_changed?")
    return true if !opt[:switch].nil? && send(opt[:switch]+"_changed?")
    false
  end
  
  def apply_mods_on_create()
    apply_mods(true)
  end
  
  def apply_mods(create = false)
    self.class.apply_mods_opt.each do |opt|
      val = apply_mods?(opt) ? send(opt[:prop]) : nil
      if opt[:direct]
        modificators_direct.update_all(:modifiable => val)
      end
      unless opt[:provider].nil?
        send(opt[:provider]).modificators.indirect_link_to(val,self,create)
      end
    end
  end
  
  def update_mods
    self.class.apply_mods_opt.each do |opt|
      if apply_mods_state_changed?(opt)
        val = apply_mods?(opt) ? send(opt[:prop]) : nil
        if opt[:direct]
          modificators_direct.update_all(:modifiable => val)
        end
        unless opt[:provider].nil?
          modifications.update_all(:modifiable => val)
        end
      end
    end
  end
  
  module ClassMethods
    @@apply_mods_opt = []
    attr_writer :apply_mods_opt
    def apply_mods_opt
      @@apply_mods_opt
    end
    
    def apply_mods_to(prop,opt)
      default = {direct: true, switch: nil, provider: nil}
      self.apply_mods_opt.push(default.merge({prop: prop}.merge(opt)))
    end
    
  end

end