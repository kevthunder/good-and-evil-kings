class CreateSoldierTypes < ActiveRecord::Migration
  def change
    create_table :soldier_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
