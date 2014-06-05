module Modifiable
  extend ActiveSupport::Concern

  included do
    has_many :modificators_direct, class_name: :Modificator, :as => :modifiable
    has_many :modifications, :as => :modifiable
    has_many :modificators_indirect, :through => :modifications
  end

  def modificators 
    Modificator.joins(:modifications).where('(modifications.modifiable_type = :type AND modifications.modifiable_id = :id)' \
                                      + ' OR (modificators.modifiable_type = :type AND modificators.modifiable_id = :id)',
                                      {type: self.class.model_name.to_s, id: id}
                                   )
  end
  
  def update_prop_mod(prop) 
    prop_opt = Modificator.parse_prop_opt(prop)
    val = get_prop_mod(prop)
    if self.respond_to?( prop_opt[:name] )
      self.send(prop_opt[:name], *prop_opt[:args], val)
    end
  end
  def get_prop_mod(prop)
    prop_opt = Modificator.parse_prop_opt(prop)
    default = 0
    def_method = 'default_' + prop_opt[:name]
    if self.respond_to?( def_method )
      default = self.send(def_method, *prop_opt[:args])
    end
    val = default;
    mods = Modificator.where(prop: prop).order(:multiply)
    mods.each do |mod|
      val = mod.apply(val)
    end
    val
  end
  
  module ClassMethods
    
  end

end