class AddPopToCastles < ActiveRecord::Migration
  def change
    add_column :castles, :pop, :integer
  end
end
