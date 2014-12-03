class Message < ActiveRecord::Base
  belongs_to :destination, polymorphic: true
  belongs_to :sender, polymorphic: true

  serialize :data
  
  scope :viewable_by, (lambda do |user|
    test_user = Arel::Nodes::Grouping.new(Message.where(destination: user).where_values.reduce(:and))
    test_kingdom = Arel::Nodes::Grouping.new(Message.where(destination: user.current_kingdom).where_values.reduce(:and))
    where(test_user.or(test_kingdom))
  end)
  
end
