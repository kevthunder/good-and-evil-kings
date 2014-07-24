class AddGlobalToRessources < ActiveRecord::Migration
  def change
    add_column :ressources, :global, :boolean
  end
end
