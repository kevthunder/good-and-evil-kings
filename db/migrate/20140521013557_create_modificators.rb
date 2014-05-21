class CreateModificators < ActiveRecord::Migration
  def change
    create_table :modificators do |t|
      t.string :prop
      t.float :num
      t.boolean :multiply, null: false, default: false
      t.references :modifiable, polymorphic: true, index: true
      t.references :applier, polymorphic: true, index: true

      t.timestamps
    end
  end
end
