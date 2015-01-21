class Ai < ActiveRecord::Base
  belongs_to :castle
  after_initialize :default_values
  
  include Updated
  updated_column :next_action, :do_actions
  
  def default_values
      self.next_action ||= DateTime.now
  end
  
  def do_actions()
    do_systematic_actions()
    do_random_action()
    self.next_action = DateTime.now + rand(12.hour..36.hour)
    save
  end
  
  def do_systematic_actions()
    AiAction.systematic.executable_for(self).each do |action|
      do_action(action)
    end
  end
  
  def do_random_action()
    do_action(AiAction.occasional.random_executable_for(self))
  end
  
  def do_action(action)
    action = AiAction.find_by_type(action) unless action.respond_to?(:execute_for)
    action.execute_for self unless action.nil?
  end
  
  def tax_collected(mission)
    mission.redeem
  end
  
  class << self
    def new_scattered(point,max_side_size,scatter_size = 400,min_spacing = 40)
      
      zone = Zone.new_centered_on(point,scatter_size*2)
      pos = Tile.where(tiled_type:"Castle").find_empty_spot(zone,min_spacing)
      return nil if pos.nil?
      
      kingdom = Kingdom.available_or_create_for_size(max_side_size)
      existing_tiles = Tile.where(tiled_type:"Castle").within_square_dist(point,scatter_size+min_spacing).to_a
      
      new(
        castle: Castle.new_auto_named(
          kingdom: kingdom,
          tile: pos
        )
      )
    end
    def create_scattered(point,max_side_size)
      res = new_scattered(point,max_side_size)
      res.save!
      res
    end
  end
end
