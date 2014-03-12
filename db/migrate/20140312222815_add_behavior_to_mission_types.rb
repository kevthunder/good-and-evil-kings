class AddBehaviorToMissionTypes < ActiveRecord::Migration
  def change
    add_column :mission_types, :behavior, :string
  end
end
