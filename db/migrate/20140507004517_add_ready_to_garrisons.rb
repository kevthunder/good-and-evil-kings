class AddReadyToGarrisons < ActiveRecord::Migration
  def change
    add_column :garrisons, :ready, :datetime
  end
end
