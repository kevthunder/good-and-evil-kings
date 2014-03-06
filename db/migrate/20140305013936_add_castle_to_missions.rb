class AddCastleToMissions < ActiveRecord::Migration
  def change
    add_reference :missions, :castle, index: true
  end
end
