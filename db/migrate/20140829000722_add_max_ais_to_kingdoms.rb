class AddMaxAisToKingdoms < ActiveRecord::Migration
  def change
    add_column :kingdoms, :max_ais, :integer, :null => false, :default => 0
  end
end
