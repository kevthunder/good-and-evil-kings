class Mission < ActiveRecord::Base
  belongs_to :mission_type, primary_key: 'class_name', foreign_key: 'type'
  belongs_to :mission_status, primary_key: 'code', foreign_key: 'mission_status_code'
  belongs_to :castle
  belongs_to :target, polymorphic: true
  belongs_to :kingdom
  has_many :stocks, ->{ extending Quantifiable::HasManyExtension }, as: :stockable
  has_many :garrisons, ->{ extending Garrison::HasManyExtension }, as: :garrisonable
  has_many :options, as: :target
  has_one :movement, dependent: :destroy
  accepts_nested_attributes_for :stocks, :garrisons, :options, allow_destroy: true

  before_create :start_behavior
  validates_presence_of :kingdom_id
  validate :target_and_castle_must_differ_or_allowed
  
  include Updated
  updated_column :next_event, :next

  extend InheritenceBaseNaming
  
  def next
    self.next_event = nil
    unless mission_status_code.nil?
      update_status 
    end
    save! unless destroyed?
  end

  attr_accessor :start_status
  def add_sequence(seq)
    @sequences = [] unless instance_variable_defined?(:@sequences)
    self.start_status = seq[0] if start_status.nil?
    @sequences.push(seq)
  end

  def next_status
    return @next_status unless @next_status.nil?
    return nil if mission_status_code.nil? || !@sequences
    @sequences.each do |seq|
      pos = seq.index(mission_status_code)
      return nil if pos == seq.length - 1
      return seq[pos + 1] unless pos.nil?
    end
  end

  attr_writer :next_status

  def update_status(code = nil)
    self.next_status = code
    send('end_' + mission_status_code) if !mission_status_code.nil? && respond_to?('end_' + mission_status_code)
    unless destroyed?
      self.mission_status_code = next_status
      send('start_' + mission_status_code) if !mission_status_code.nil? && respond_to?('start_' + mission_status_code)
    end
  end

  
  def actions
    []
  end
  
  def actions_list
    Hash[*actions.map{ |a| [a, a.humanize] }.flatten]
  end

  def create_movement(direction)
    if direction == :going
      start_tile = castle.tile
      end_tile = target_tile
    else
      start_tile = target_tile
      end_tile = castle.tile
    end
    self.movement = Movement.new(
      start_time: Time.now,
      end_time: next_event,
      start_tile_attributes: {x: start_tile.x, y: start_tile.y},
      end_tile_attributes: {x: end_tile.x, y: end_tile.y}
    )
  end
  
  def target_tile
    target.tile
  end
  
  def cur_pos
    return nil if movement.nil?
    movement.cur_pos
  end
  
  def belongs_to?(user)
    kingdom.user_id == user.id
  end
  
  def to_partial_path
    "missions/mission"
  end
  

  scope :concerning, (lambda do |thing|
    if thing.class.model_name == 'Castle'
      where('target_id = :id or castle_id = :id',{ id: thing.id })
    else
      where(target_id: thing.id)
    end
  end)
  
  scope :viewable_by, (lambda do |user|
    joins(:kingdom).where(kingdoms: { user_id: user.id })
  end)
  
  scope :ended, (lambda do
    where(mission_status_code:nil)
  end)
  
  scope :ongoing, (lambda do
    where.not(mission_status_code:nil)
  end)
  
  class << self
    def needs_field(field_name)
      return send("needs_field_" + field_name.to_s) if respond_to?("needs_field_" + field_name.to_s)
      false
    end
    
    def needs_field_castle_id
      true
    end
    
    def opt_read_val(opt)
      return send("opt_" + opt.name + "_read_val", opt) if respond_to?("opt_" + opt.name + "_read_val")
      nil
    end
    
    def allow_same_target_and_castle?
      false
    end
  end
  
  def calcul_travel_time
    garrisons.travel_time_between(castle, target_tile)
  end
  
  private

  def unsaved_garrisons
    new_record? || garrisons.loaded? && garrisons.count == 0 && garrisons.size > 0
  end

  def start_behavior
    start
  end

  def start
    update_status(start_status) unless start_status.nil?
  end

  def allow_same_target_and_castle?
    self.class.allow_same_target_and_castle?
  end
  
  def target_and_castle_differs?
    !target_id.nil? && target_id == castle_id && target_type == Castle.model_name.to_s
  end
  
  def target_and_castle_must_differ_or_allowed
    target_and_castle_must_differ unless allow_same_target_and_castle?
  end
  
  def target_and_castle_must_differ
    errors.add(:garrisons, 'must have at least one soldier') if target_and_castle_differs?
  end
  
  def must_have_one_garrison
    errors.add(:garrisons, 'must have at least one soldier') if garrisons.empty? || garrisons.all? { |garrison| garrison.marked_for_destruction? }
  end

  def must_have_one_stock
    errors.add(:stocks, 'must have at least one ressource') if stocks.empty? || stocks.all? { |stock| stock.marked_for_destruction? }
  end

  def garrisons_must_be_available
    errors.add(:garrisons, 'You cant send more soldier than you have at this castle') unless castle.garrisons.check_disponibility?(garrisons)
  end
end
