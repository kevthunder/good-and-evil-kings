class CreateCastles < ActiveRecord::Migration
  def change
    create_table :castles do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
