class CreateAiActions < ActiveRecord::Migration
  def change
    create_table :ai_actions do |t|
      t.string :type
      t.integer :weigth

      t.timestamps
    end
  end
end
