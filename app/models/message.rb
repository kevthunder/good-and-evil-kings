class Message < ActiveRecord::Base
  belongs_to :destination, polymorphic: true
  belongs_to :sender, polymorphic: true

  serialize :data
  
  scope :viewable_by, (lambda do |user|
    test_user = Arel::Nodes::Grouping.new(Message.where(destination: user).where_values.reduce(:and))
    if user.current_kingdom.nil?
      where(test_user)
    else
      test_kingdom = Arel::Nodes::Grouping.new(Message.where(destination: user.current_kingdom).where_values.reduce(:and)) unless user.current_kingdom
      where(test_user.or(test_kingdom))
    end
  end)
  
end
