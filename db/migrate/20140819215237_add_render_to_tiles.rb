class AddRenderToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :render, :boolean
  end
end
