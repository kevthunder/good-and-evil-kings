class AddMaxStockToCastles < ActiveRecord::Migration
  def change
    add_column :castles, :max_stock, :integer
  end
end
