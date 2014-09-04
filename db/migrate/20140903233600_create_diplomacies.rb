class CreateDiplomacies < ActiveRecord::Migration
  def change
    create_table :diplomacies do |t|
      t.integer :karma
      t.references :from_kingdom, index: true
      t.references :to_kingdom, index: true
      t.datetime :last_interaction

      t.timestamps
    end
  end
end
