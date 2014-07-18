module Quantifiable
  extend ActiveSupport::Concern
  
  module Collection
    
  end
  
  module HasManyExtension
    def qte
      return to_a.sum{ |g| g.qte} if proxy_association.owner.new_record?
      super
    end
  end
  
  module ClassMethods
    def qte
      sum 'qte'
    end
    
    include Quantifiable::Collection
  
    private
    
    attr_accessor :quantified
  end
end