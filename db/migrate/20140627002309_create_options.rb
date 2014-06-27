class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.string :val
      t.references :target, polymorphic: true, index: true

      t.timestamps
    end
  end
end
