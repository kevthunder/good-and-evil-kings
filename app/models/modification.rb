class Modification < ActiveRecord::Base
  belongs_to :modificator
  belongs_to :modifiable_indirect, :foreign_key => :modifiable_id, :foreign_type => :modifiable_type, polymorphic: true
  alias_attribute :modifiable, :modifiable_indirect
  belongs_to :applier, polymorphic: true
end
