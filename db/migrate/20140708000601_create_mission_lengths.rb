class CreateMissionLengths < ActiveRecord::Migration
  def change
    create_table :mission_lengths do |t|
      t.string :label
      t.integer :seconds
      t.float :reward
      t.references :target, polymorphic: true, index: true

      t.timestamps
    end
  end
end
