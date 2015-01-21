class AddAllwaysToAiActions < ActiveRecord::Migration
  def change
    add_column :ai_actions, :allways, :boolean
  end
end
