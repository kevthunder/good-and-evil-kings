class AssistMission < Mission
  validate :must_have_one_worker, on: :create
  validate :garrisons_must_be_available, on: :create
  
  include TimedMission
  
  after_initialize :after_initialize
  def after_initialize()
    add_sequence(['going','working','returning'])
  end
  
  def start
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
  end
  
  def start_returning
    create_movement :returning
  end
  
  def end_returning
    movement.destroy! unless movement.nil?
    castle.garrisons.add garrisons
    castle.stocks.add stocks
  end
  
  
  def reward(remaining = 1)
    ressources = [Ressource.food,Ressource.wood,Ressource.stone]
    Garrison.new_collection(ressources.map{ |r|
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
  
  def redeem
    target.stocks.add_qty(reward(remaining).to_i ,:Coins)
    destroy
  end
  
  def actions
    actions = super
    if mission_status_code == "waiting"
      actions.push('redeem')
    end
    actions
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