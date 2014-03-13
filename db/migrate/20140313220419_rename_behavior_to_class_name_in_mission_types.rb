class RenameBehaviorToClassNameInMissionTypes < ActiveRecord::Migration
  def change
    rename_column :mission_types, :behavior, :class_name
  end
end
