class AddRecruitableQtyToCastles < ActiveRecord::Migration
  def change
    add_column :castles, :recruitable_qty, :integer
  end
end
