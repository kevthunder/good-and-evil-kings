class ChangeStatusRelationInMissions < ActiveRecord::Migration
  def change
    remove_reference :missions, :mission_status, index: true
    add_column :missions, :mission_status_code, :string
    add_index :missions, :mission_status_code
  end
end
