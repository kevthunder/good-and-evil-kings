class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.references :mission_type, index: true
      t.references :mission_status, index: true

      t.timestamps
    end
  end
end
