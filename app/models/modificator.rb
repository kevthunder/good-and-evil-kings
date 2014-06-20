class Modificator < ActiveRecord::Base
  belongs_to :modifiable_direct, :foreign_key => :modifiable_id, :foreign_type => :modifiable_type, polymorphic: true
  belongs_to :applier, polymorphic: true
  has_many :modifications
  after_save :update_modifiable
  after_create :update_modifiable
  # has_many :modifiable_indirect, :through => :modifications, :source_type => :Modification
  
  def apply(val,target,applier = nil)
    applier = applier || self.applier
    num = self.num
    return val if applier.respond_to?('apply_mod?') && !applier.apply_mod?(self,target)
    if applier.respond_to?('alter_mod')
      num = applier.alter_mod(self.dup).num
    end
    if multiply
      val * num
    else
      val + num
    end
  end
  
  def update_modifiable()
    modifications.each { |m| m.update_modifiable } unless modifications.count > 10
    modifiable_direct.update_prop_mod(prop) unless modifiable_direct.nil?
  end
  
  def indirect_link_to(modifiable, applier = nil, create = false)
    modifications = modifiable.nil? ? Modification.where(modifiable_id: nil) : modifiable.modifications
    existing = create ? nil : modifications.where( modificator_id: id, applier: applier ).first
    if existing.nil?
      Modification.create(modifiable:modifiable, modificator_id: id, applier: applier )
    end
  end
    
  class << self
    def update_modifiables(modifiable)
      all.each do |mod|
        mod.modifiable = modifiable
        mod.save!
      end
    end
  
    def indirect_link_to(modifiable, applier = nil, create = false) 
      modifiable.modifications.load unless modifiable.nil?
      all.each do |m|
        m.indirect_link_to(modifiable, applier)
      end
    end
    
    def each_with_applier(indirect=true)
      if indirect
        indirect_ids = pluck('modifications.id').to_a
        modifications = Modification.unscoped.where(id: indirect_ids).to_a
        indirect = indirect_ids.map{ |id| modifications.find{ |m| m.id == id } }
      end
      all.each_with_index{ |m,i|
        yield(m, (indirect[i] || m).applier)
      }
    end
  
    def parse_prop_opt(prop)
      split = prop.to_s.split(':')
      {
        name: split.first,
        args: split.length > 1 ? split.last.split(';') : []
      }
    end
  end
end
