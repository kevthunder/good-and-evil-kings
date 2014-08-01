class RenameMachineNameToAliasForSoldierTypes < ActiveRecord::Migration
  def change
    rename_column :soldier_types, :machine_name, :alias
  end
end
