class AddTypeToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :type, :string
  end
end
