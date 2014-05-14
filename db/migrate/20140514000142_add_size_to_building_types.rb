class AddSizeToBuildingTypes < ActiveRecord::Migration
  def change
    add_column :building_types, :size_x, :integer
    add_column :building_types, :size_y, :integer
  end
end
