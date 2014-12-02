class CreateMessagesMessagesCategories < ActiveRecord::Migration
  def change
    create_table :messages_messages_categories do |t|
      t.references :message_category, index: true
      t.references :message, index: true

      t.timestamps
    end
  end
end
