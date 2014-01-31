class RemoveModelFromTiles < ActiveRecord::Migration
  def change
    remove_column :tiles, :model
  end
end
