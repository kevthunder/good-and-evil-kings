class Modificator < ActiveRecord::Base
  belongs_to :modifiable, polymorphic: true
  belongs_to :applier, polymorphic: true
end
