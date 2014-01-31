class AddKindomToCastle < ActiveRecord::Migration
  def change
    add_reference :castles, :kingdom, index: true
  end
end
