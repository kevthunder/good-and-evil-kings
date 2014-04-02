class AddEndTimeToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :end_time, :datetime
  end
end
