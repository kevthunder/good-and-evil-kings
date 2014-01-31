class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.datetime :time
      t.references :actionnable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
