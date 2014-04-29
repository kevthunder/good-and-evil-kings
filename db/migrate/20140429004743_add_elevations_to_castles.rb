class AddElevationsToCastles < ActiveRecord::Migration
  def change
    add_column :castles, :elevations_map, :string
  end
end
