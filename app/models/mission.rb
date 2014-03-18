class Mission < ActiveRecord::Base
  belongs_to :mission_type, primary_key: "class_name", foreign_key: "type"
  belongs_to :mission_status, primary_key: "code", foreign_key: "mission_status_code"
  belongs_to :castle
	belongs_to :target, polymorphic: true
  has_many :stocks, as: :stockable
  has_many :garrisons, as: :garrisonable
  
  accepts_nested_attributes_for :stocks, :garrisons, allow_destroy: true
  
  before_create :startBehavior
  
  
  def next()
  end
  
  private
    def startBehavior
      self.start
    end
    
    def start()
      
    end
    
    def must_have_one_garrison
      errors.add(:garrisons, 'must have at least one soldier') if (garrisons.empty? or garrisons.all? {|garrison| garrison.marked_for_destruction? })
    end
    def must_have_one_stock
      errors.add(:stocks, 'must have at least one ressource') if (stocks.empty? or stocks.all? {|stock| stock.marked_for_destruction? })
    end

end
