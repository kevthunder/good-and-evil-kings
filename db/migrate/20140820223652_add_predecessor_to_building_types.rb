class AddPredecessorToBuildingTypes < ActiveRecord::Migration
  def change
    add_reference :building_types, :predecessor, index: true
  end
end
