class AddMissionToMovements < ActiveRecord::Migration
  def change
    add_reference :movements, :mission, index: true
  end
end
