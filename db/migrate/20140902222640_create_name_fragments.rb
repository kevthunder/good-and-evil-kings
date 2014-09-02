class CreateNameFragments < ActiveRecord::Migration
  def change
    create_table :name_fragments do |t|
      t.string :name
      t.string :pos
      t.string :group

      t.timestamps
    end
  end
end
