module Modifiable
  extend ActiveSupport::Concern

  included do
    has_many :modificators_direct, class_name: :Modificator, :as => :modifiable
    has_many :modifications, :as => :modifiable
    has_many :modificators_indirect, :through => :modifications
    
    after_initialize :init_created_prop_mod
  end

  def modificators 
    Modificator.joins(:modifications).where('(modifications.modifiable_type = :type AND modifications.modifiable_id = :id)' \
                                      + ' OR (modificators.modifiable_type = :type AND modificators.modifiable_id = :id)',
                                      {type: self.class.model_name.to_s, id: id}
                                   )
  end
  
  def init_created_prop_mod
    update_all_prop_mod(false) if new_record?
  end
  
  def update_all_prop_mod(save = true) 
    modificators = self.class.prop_mod_list
    modificators += self.modificators.group(:prop).pluck(:prop).to_a unless new_record?
    modificators.uniq{ |p| p.to_s }.each do |prop|
      update_prop_mod(prop,save)
    end
  end
  
  def update_prop_mod(prop, save = true) 
    prop_opt = Modificator.parse_prop_opt(prop)
    val = get_prop_mod(prop)
    if self.respond_to?( prop_opt[:name]+"=" )
      self.send(prop_opt[:name]+"=", *prop_opt[:args], val)
    elsif self.respond_to?( prop_opt[:name] )
      self.send(prop_opt[:name], *prop_opt[:args], val)
    end
    self.save if changed? && save
  end
  
  def default_prop_mod(prop)
    prop_opt = Modificator.parse_prop_opt(prop)
    def_method = 'default_' + prop_opt[:name]
    return self.send(def_method, *prop_opt[:args]) if self.respond_to?( def_method )
    0
  end
  
  def get_prop_mod(prop)
    val = default_prop_mod(prop);
    unless new_record?
      mods = modificators.where(prop: prop).order(:multiply)
      mods.each_with_applier do |mod,applier|
        val = mod.apply(val,self,applier)
      end
    end
    val
  end
  
  module ClassMethods
    attr_writer :prop_mod_list
    def prop_mod_list
      @prop_mod_list ||= []
    end
    
    def prop_mod(prop,opt = {})
      self.prop_mod_list.push(prop);
      
      unless opt[:default].nil?
        define_method("default_#{prop}") { opt[:default] }
      end
    end
  end

end