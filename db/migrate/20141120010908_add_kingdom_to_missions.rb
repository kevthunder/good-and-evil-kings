class AddKingdomToMissions < ActiveRecord::Migration
  def change
    add_reference :missions, :kingdom, index: true
  end
end
