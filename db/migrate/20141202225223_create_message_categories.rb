class CreateMessageCategories < ActiveRecord::Migration
  def change
    create_table :message_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
