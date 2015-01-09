class AddMaxToBuildingType < ActiveRecord::Migration
  def change
    add_reference :building_types, :base, index: true
    add_column :building_types, :max_instances, :integer
  end
end
