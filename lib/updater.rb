class Updater

  class UpdaterCallback
    def initialize(target,call_method,order_method)  
      @order_method, @target, @call_method  = order_method, target, call_method
    end
    
    def trigger
      unless target.respond_to( :destroyed? )  && target.destroyed?
        target.send(call_method)
      end
    end
    
    def order
      target.send(order_method)
    end
    attr_accessor :order_method, :target, :call_method
  end
  
  @@updated = []
  class << self
    def add_updated(obj)
      if obj.respond_to?(:get_update_callbacks)
        @@updated.push(obj)
      end
    end
    
    def updated
      # load all models
      Rails.application.eager_load!
      
      @@updated
    end
    
    def all_update_callbacks
      updated.map{ |obj|
        obj.get_update_callbacks
      }.flatten(1)
    end
    
    def update
      all_update_callbacks.sort_by{ |c| c.order }.each do |c|
        c.trigger
      end
    end
  end
end