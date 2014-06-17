class AddBreakpointToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :breakpoint_time, :datetime
  end
end
