class AddBuildTimeToBuildingTypes < ActiveRecord::Migration
  def change
    add_column :building_types, :build_time, :integer
  end
end
