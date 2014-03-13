class RemoveMissionTypeFromMissions < ActiveRecord::Migration
  def change
    remove_reference :missions, :mission_type, index: true
  end
end
