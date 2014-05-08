class Updater
  @@updated = []
  class << self
    def add_updated(obj)
      if obj.respond_to?(:update)
        @@updated.push(obj)
      end
    end
    
    def update
      @@updated.each do |obj|
        obj.update
      end
    end
  end
end