class AddTargetToMissions < ActiveRecord::Migration
  def change
    add_reference :missions, :target, polymorphic: true, index: true
  end
end
