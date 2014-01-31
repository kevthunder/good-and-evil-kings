class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.string :model
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
