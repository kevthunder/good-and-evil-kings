class Modificator < ActiveRecord::Base
  belongs_to :modifiable_direct, :foreign_key => :modifiable_id, :foreign_type => :modifiable_type, polymorphic: true
  belongs_to :applier, polymorphic: true
  has_many :modifications
  # has_many :modifiable_indirect, :through => :modifications, :source_type => :Modification
end
