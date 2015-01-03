class CreateSpawnPoints < ActiveRecord::Migration
  def change
    create_table :spawn_points do |t|
      t.integer :delta
      t.references :castle, index: true

      t.timestamps
    end
  end
end
