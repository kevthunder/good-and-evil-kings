class CreateMissionStatuses < ActiveRecord::Migration
  def change
    create_table :mission_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
