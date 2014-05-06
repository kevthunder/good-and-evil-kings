class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :x
      t.integer :y
      t.references :building_type, index: true
      t.references :castle, index: true

      t.timestamps
    end
  end
end
