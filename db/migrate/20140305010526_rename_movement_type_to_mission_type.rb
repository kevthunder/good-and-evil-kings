class RenameMovementTypeToMissionType < ActiveRecord::Migration
  def change
    rename_table :movement_types, :mission_types
  end
end
