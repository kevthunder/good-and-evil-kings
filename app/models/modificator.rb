class Modificator < ActiveRecord::Base
  belongs_to :modifiable_direct, :foreign_key => :modifiable_id, :foreign_type => :modifiable_type, polymorphic: true
  belongs_to :applier, polymorphic: true
  has_many :modifications
  after_save :update_modifiable
  after_create :update_modifiable
  # has_many :modifiable_indirect, :through => :modifications, :source_type => :Modification
  
  def apply(val)
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
  
  def indirect_link_to(modifiable, applier = nil)
    existing = modifiable.modifications.where( modificator_id: id, applier_id: (applier.nil? ? nil : applier.id) ).first
    if existing.nil?
      modifiable.modifications.create(modificator_id: id, applier: applier )
    end
  end
    
  class << self
    def indirect_link_to(modifiable, applier = nil) 
      modifiable.modifications.load
      all.each do |m|
        m.indirect_link_to(modifiable, applier)
      end
    end
    
    def each_with_applier(indirect=true)
      if(indirect){
        indirect_ids = pluck('modifications.id').to_a
        modifications = Modification.where(id: indirect_ids).to_a
        indirect = indirect_ids.map{ |id| modifications.find{ |m| m.id == id } }
      }
      all.each_with_index{ |m,i|
        yield(m, indirect[i] || m.applier)
      }
    end
  
    def parse_prop_opt(prop)
      {
        name: prop.split(':').first,
        args: prop.split(':').last.split(';')
      }
    end
  end
end
