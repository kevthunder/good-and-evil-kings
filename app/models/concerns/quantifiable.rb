module Quantifiable
  extend ActiveSupport::Concern
  
  class Collection
    attr_reader :model
    attr_reader :arr
    
    def initialize(model, *args)
      @model = model
      @arr = Array.new(*args)
    end
    
    def match(quantifiables)
      return match_single(quantifiables) unless quantifiables.respond_to?('map')
      model.new_collection(select{ |q1| quantifiables.any?{ |q2| q2.can_unite?(q1) } })
    end
    
    def match_single(quantifiable)
      match(new_collection([quantifiable])).first
    end
    
    def take_any(number)
      res = model.new_collection();
      
      total = self.qte
      number = [number,total].min
      each do |quantifiable|
        qte = quantifiable.qte * number / total
        number -= qte
        total -= quantifiable.qte
        yield(qte,quantifiable) if block_given?
        res.push(model.new(:qte => qte, model.quantified_key => quantifiable.send(model.quantified_key))) if qte > 0
      end
      res
    end
    
    def subtract_any(number)
      take_any(number) do |qte,quantifiable|
        if quantifiable.qte == qte
          quantifiable.destroy
        else
          quantifiable.qte -= qte
          quantifiable.save
        end
      end
    end
    
    def qte
      to_a.sum{ |g| g.qte}
    end
    
    def multiply(num)
      res = model.new_collection();
      each do |quantifiable|
        res.push(model.new(:qte => quantifiable.qte * num, model.quantified_key => quantifiable.send(model.quantified_key)))
      end
      res
    end
    
    alias :respond_to_direct? :respond_to?
    
    def respond_to?(name)
      super || arr.respond_to?(name)
    end
    
    def wrapped_methods
      [:select,:reject]
    end
    
    def method_missing(name, *args, &block)
      if !respond_to_direct?(name) && arr.respond_to?(name)
        res = arr.send(name, *args, &block)
        return model.new_collection(res) if wrapped_methods.include?(name) || (res.respond_to?("all?") && res.all?{ |i| i.is_a?(model) } && res.count > 0)
        res
      else
        super
      end
    end
    
  end
  
  module HasManyExtension
    def qte
      return to_a.sum{ |g| g.qte} if proxy_association.owner.new_record?
      super
    end
    
    def new_records
      target.select{ |r| r.new_record? }
    end
    
    def to_collection
      new_collection(to_a)
    end
    
    private
    
    def method_missing(name, *args, &block)
      if !respond_to?(name) && collection_type.method_defined?(name)
        to_collection.send(name, *args, &block)
      else
        super
      end
    end
  end
  
  included do
    scope :match, (lambda do |quantifiables|
      return match_single(quantifiables) unless quantifiables.respond_to?('map')
      where quantified_key => quantifiables.map{ |s| s.send(quantified_key) }
    end)
    scope :match_single, (lambda do |quantifiable|
      match(new_collection([quantifiable])).first
    end)
  end
  
  def can_unite?(quantifiable)
      send(self.class.quantified_key) == quantifiable.send(self.class.quantified_key)
  end
  
  module ClassMethods
    def empty_all
      all.each do |quantifiable|
        quantifiable.qte = 0
        quantifiable.save!
      end
    end
    
    def qte
      sum 'qte'
    end
    
    def collection_type
      Quantifiable::Collection
    end
    
    def new_collection(quantifiables = nil)
      return collection_type.new(self) if quantifiables.nil?
      return quantifiables if quantifiables.is_a?(collection_type)
      return quantifiables.to_collection if quantifiables.respond_to?(:to_collection)
      quantifiables = [quantifiables] unless quantifiables.respond_to?('each') || quantifiables.respond_to?('all')
      collection_type.new(self,quantifiables)
    end
    
    def new_enumerable(quantifiables)
      return new_collection(quantifiables) if !quantifiables.is_a?(collection_type) && ((!quantifiables.respond_to?('each') && !quantifiables.respond_to?('all')) || quantifiables.is_a?(Array))
      quantifiables
    end
    
    def to_collection
      new_collection(all.to_a)
    end
    
    def can_subtract?(quantifiables)
      quantifiables = new_collection(quantifiables)
      matchings = match(quantifiables).to_a

      quantifiables.each do |quantifiable|
        matched = matchings.select { |s| s.can_unite?(quantifiable) }.first
        return false if matched.nil? || matched.qte < quantifiable.qte
      end
      true
    end
    
    def subtract(quantifiables)
      quantifiables = new_collection(quantifiables)
      matchings = match(quantifiables).to_a

      quantifiables.each do |quantifiable|
        matched = matchings.select { |s| s.can_unite?(quantifiable) }.first
        return false if matched.nil? || matched.qte < quantifiable.qte
        if matched.qte == quantifiable.qte
          matched.destroy
        else
          matched.qte -= quantifiable.qte
          matched.save
        end
      end
      true
    end
    
    def add(quantifiables)
      quantifiables = new_collection(quantifiables)
      matchings = all.match(quantifiables).to_a

      quantifiables.each do |quantifiable|
        matched = matchings.select { |s| s.can_unite?(quantifiable) }.first
        if matched.nil?
          all.create(qte: quantifiable.qte, ressource_id: quantifiable.ressource_id)
        else
          matched.qte += quantifiable.qte
          matched.save!
        end
      end
    end
    
    def transfer(quantifiables)
      quantifiables = new_collection(quantifiables)
      matchings = all.match(quantifiables).to_a

      quantifiables.each do |quantifiable|
        matched = matchings.select { |s| s.can_unite?(quantifiable) }.first
        if matched.nil?
          all.add(quantifiable)
        else
          matched.qte += quantifiable.qte
          matched.save!
          quantifiable.destroy
        end
      end
    end
    
    attr_accessor :quantified
    def quantified
      @quantified || (Object.const_defined?( model_name.to_s + "Type" ) ? Object.const_get( model_name.to_s + "Type" ) : nil )
    end
    
    attr_writer :quantified_key
    def quantified_key
      @quantified_key || (quantified ? quantified.model_name.to_s.underscore + "_id" : nil)
    end
    
    private
    
    def method_missing(name, *args, &block)
      if !respond_to?(name) && collection_type.method_defined?(name)
        to_collection.send(name, *args, &block)
      else
        super
      end
    end
    
  end
end