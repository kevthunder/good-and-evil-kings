class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
      t.references :modificator, index: true
      t.references :modifiable, polymorphic: true, index: true
      t.references :applier, polymorphic: true, index: true

      t.timestamps
    end
  end
end
