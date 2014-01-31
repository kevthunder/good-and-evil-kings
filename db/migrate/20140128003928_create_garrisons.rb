class CreateGarrisons < ActiveRecord::Migration
  def change
    create_table :garrisons do |t|
      t.integer :qte
      t.references :kingdom, index: true
      t.references :soldier_type, index: true
      t.references :garrisonable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
