class AddMilitaryToSoldierTypes < ActiveRecord::Migration
  def change
    add_column :soldier_types, :military, :boolean
  end
end
