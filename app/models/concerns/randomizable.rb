module Randomizable
  extend ActiveSupport::Concern
  
  included do
    scope :randoms, (lambda do 
      order = ActiveRecordUtil.random_funct
      if rnd_weight_col
        order += '/' + table_name + "." + rnd_weight_col
        return where.not(rnd_weight_col => 0).order(order)
      end
      order(order)
    end)
  end
  
  module ClassMethods
    def random
      randoms.first
    end
    
    attr_writer :rnd_weight_col
    def rnd_weight_col
      @rnd_weight_col.nil? ? ( column_names.include?("weight") ? "weight" : nil) : @rnd_weight_col
    end
  end
end