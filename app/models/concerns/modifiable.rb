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
  
  module ClassMethods
    
  end

end