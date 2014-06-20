module Buyable
  extend ActiveSupport::Concern

  included do
    if self.attribute_method?(:ready)
      Updater.add_updated self
      scope :to_update, -> { where('ready < ?', Time.now) }
      scope :ready, -> { where(ready: nil) }
    end
    validate :able_to_buy, on: :create
    before_create :on_bougth
    after_create :buy
  
    attr_accessor :bougth
  end

  def able_to_buy
    unless can_buy? || !bougth
      if self.respond_to? :qte
        errors.add(:qte, "is too big. Cant afford that much.")
      else
        errors.add(:base, "Cant afford.")
      end
    end
  end
  
  def can_buy?
    return cost.can_subtract_from? buyer
  end
  
  def buy
    cost.subtract_from buyer if bougth
  end
  
  def on_bougth
    self.ready = calcul_ready if bougth && readyable
  end
  
  def is_ready
    ready.nil?
  end
  def is_ready_changed?
    ready_changed?
  end
  
  def calcul_ready
    Time.now + buy_time
  end
  
  def on_ready
    self.ready = nil
    save!
  end
  
  def cost
    costs = buyable_type.costs.multiply(self.respond_to?(:qte) ? qte : 1)
  end
  
  def readyable
    self.respond_to?(:ready) && !buy_time.nil?
  end
  
  def buy_time
    if buyable_type.respond_to?(:buy_time)
      buyable_type.buy_time 
    else
      nil
    end
  end
  
  module ClassMethods
    def update
      if method_defined? :on_ready
        to_update.each do |garrison|
          garrison.on_ready
        end
      end
    end
  end

end