class Updater

  class UpdaterCallback
    def initialize(target,call_method,order_method)  
      @order_method, @target, @call_method  = order_method, target, call_method
    end
    
    def trigger
      unless target.respond_to?( :destroyed? )  && target.destroyed?
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
    attr_writer :before_every_actions

    def before_every_actions
      return true if @before_every_actions.nil?
      @before_every_actions
    end
  
  
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
      objects = all_update_callbacks.map{ |c| c.target }.uniq
      objects.each do |o|
        o.set_context_objects(objects) if o.respond_to?(:set_context_objects)
      end
      all_update_callbacks.sort_by{ |c| c.order }.each do |c|
        c.trigger
      end
    end
  end
end