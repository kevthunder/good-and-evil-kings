class AddReadyToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :ready, :datetime
  end
end
