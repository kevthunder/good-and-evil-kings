class CreateKingdoms < ActiveRecord::Migration
  def change
    create_table :kingdoms do |t|
      t.string :name
      t.references :user, index: true
      t.integer :karma

      t.timestamps
    end
  end
end
