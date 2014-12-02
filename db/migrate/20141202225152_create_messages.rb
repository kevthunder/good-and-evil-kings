class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :text
      t.references :destination, polymorphic: true, index: true
      t.references :sender, polymorphic: true, index: true
      t.text :data
      t.string :template

      t.timestamps
    end
  end
end
