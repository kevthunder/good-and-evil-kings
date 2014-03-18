class AddDetailsToSoldierTypes < ActiveRecord::Migration
  def change
    add_column :soldier_types, :speed, :integer
    add_column :soldier_types, :attack, :integer
    add_column :soldier_types, :defence, :integer
    add_column :soldier_types, :interception, :integer
    add_column :soldier_types, :carry, :integer
  end
end
