class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.datetime :start_time
      t.references :start_tile, index: true
      t.references :end_tile, index: true

      t.timestamps
    end
  end
end
