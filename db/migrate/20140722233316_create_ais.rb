class CreateAis < ActiveRecord::Migration
  def change
    create_table :ais do |t|
      t.references :castle, index: true
      t.datetime :next_action

      t.timestamps
    end
  end
end
