class Message < ActiveRecord::Base
  belongs_to :destination, polymorphic: true
  belongs_to :sender, polymorphic: true
end
