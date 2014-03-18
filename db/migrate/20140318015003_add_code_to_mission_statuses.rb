class AddCodeToMissionStatuses < ActiveRecord::Migration
  def change
    add_column :mission_statuses, :code, :string
  end
end
