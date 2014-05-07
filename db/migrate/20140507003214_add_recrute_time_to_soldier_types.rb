class AddRecruteTimeToSoldierTypes < ActiveRecord::Migration
  def change
    add_column :soldier_types, :recrute_time, :integer
  end
end
