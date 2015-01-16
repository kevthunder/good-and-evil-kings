class AssistMission < Mission
  validate :must_have_one_worker, on: :create
  validate :garrisons_must_be_available, on: :create
  
  include TimedMission
  
  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','working','returning'])
  end
  
  def start
    garrisons.set_kingdom(kingdom)
    self.next_event = Time.now + calcul_travel_time
    super
  end
  
  def start_going
    create_movement :going
    castle.garrisons.subtract garrisons
  end
  
  def end_going
    movement.destroy! unless movement.nil?
  end
  
  def start_working
    self.next_event = Time.now + length
  end
  
  def end_working
    reward = self.reward
    stocks.add reward
    target.stocks.add reward
    # karma
    kingdom.change_karma(karma_change)
    kingdom.save
    kingdom.change_diplomacy(target.kingdom_id,10)
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    castle.garrisons.add garrisons
    castle.stocks.add stocks
  end
  
  
  def reward()
    ressources = [Ressource.food,Ressource.wood,Ressource.stone]
    Stock.new_collection(ressources.map{ |r|
      def_multi = 10
      reduce = 72000
      base = target.default_income(r.id)*def_multi + target.incomes.find_by_ressource_id(r.id).qte
      qte = base * length * garrisons.workers.qte * mission_length.reward / reduce
      Stock.new(
        qte: qte, 
        ressource:r
      )
    })
  end
  
  def karma_change
    # http://www.meta-calculator.com/online/vjblkwcz9o2h
    self_reduction = 4
    spread = 200
    base = 5
    kmod = 5
    kdiff = target.kingdom.karma - kingdom.karma / self_reduction
    (
      kdiff < 0 ? 
        (-1/(kdiff/spread-1) -1)*kmod +base
      : (-1/(kdiff/spread+1) +1)*kmod +base
    )
  end
  
  def must_have_one_worker
    errors.add(:garrisons, 'You must send at lest one worker') if garrisons.workers.qte < 1
  end
  
  class << self
    def allow_target(target,kingdom)
      target.respond_to?(:kingdom) && target.kingdom != kingdom
    end
    
    def needs_field_garrisons
      true
    end
  end
  
end