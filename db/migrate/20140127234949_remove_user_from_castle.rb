class RemoveUserFromCastle < ActiveRecord::Migration
  def change
    remove_reference :castles, :user, index: true
  end
end
