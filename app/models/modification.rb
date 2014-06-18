class Modification < ActiveRecord::Base
  belongs_to :modificator
  belongs_to :modifiable_indirect, :foreign_key => :modifiable_id, :foreign_type => :modifiable_type, polymorphic: true
  alias_attribute :modifiable, :modifiable_indirect
  belongs_to :applier, polymorphic: true
  after_save :update_modifiable
  after_create :update_modifiable
  
  def update_modifiable
    modifiable.update_prop_mod(modificator.prop) unless modifiable.nil?
  end
  
  class << self
    def update_modifiables(modifiable)
      all.each do |mod|
        mod.modifiable = modifiable
        mod.save!
      end
    end
  end
end
