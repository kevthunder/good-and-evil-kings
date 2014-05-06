class CreateBuildingTypes < ActiveRecord::Migration
  def change
    create_table :building_types do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
