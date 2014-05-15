class AddIncomesDateToCastles < ActiveRecord::Migration
  def change
    add_column :castles, :incomes_date, :datetime
  end
end
