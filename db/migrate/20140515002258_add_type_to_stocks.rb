class AddTypeToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :type, :string
    add_index :stocks, :type
  end
end
