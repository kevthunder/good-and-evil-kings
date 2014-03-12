class AddNextEventToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :next_event, :datetime
  end
end
