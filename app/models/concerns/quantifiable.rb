module Quantifiable
  extend ActiveSupport::Concern
  
  class Collection < Array
    attr_reader :model
    
    def initialize(model, *args)
      @model = model
      super(*args)
    end
    
    def match(quantifiables)
      return match_single(quantifiables) unless quantifiables.respond_to?('map')
      select{ |q1| quantifiables.any?{ |q2| q2.can_unite?(q1) } }
    end
    
    def match_single(quantifiable)
      match([quantifiable]).first
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
      Quantifiable::Collection.new(klass,to_a)
    end
    
    private
    
    def method_missing(name, *args, &block)
      if !respond_to?(name) && Quantifiable::Collection.method_defined?(name)
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
      match([quantifiable]).first
    end)
  end
  
  def can_unite?(quantifiable)
    send(quantified_key) == quantifiable.send(quantified_key)
  end
  
  module ClassMethods
  
    def qte
      sum 'qte'
    end
    
    def to_collection
      Quantifiable::Collection.new(self,all.to_a)
    end
    
    def can_subtract?(quantifiables)
      quantifiables = quantifiables.to_collection if quantifiables.respond_to?(:to_collection)
      quantifiables = [quantifiables] unless quantifiables.respond_to?('each')
      matchings = match(quantifiables).to_a

      quantifiables.each do |quantifiable|
        matched = matchings.select { |s| s.can_unite?(quantifiable) }.first
        return false if matched.nil? || matched.qte < quantifiable.qte
      end
      true
    end
    
    def subtract(quantifiables)
      quantifiables = quantifiables.to_collection if quantifiables.respond_to?(:to_collection)
      quantifiables = [quantifiables] unless quantifiables.respond_to?('each')
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
      if !respond_to?(name) && Quantifiable::Collection.method_defined?(name)
        to_collection.send(name, *args, &block)
      else
        super
      end
    end
    
  end
end