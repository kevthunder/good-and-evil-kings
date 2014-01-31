class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :qte
      t.references :ressource, index: true
      t.references :stockable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
