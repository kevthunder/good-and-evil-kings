class AddMachineNameToSoldierTypes < ActiveRecord::Migration
  def change
    add_column :soldier_types, :machine_name, :string
  end
end
