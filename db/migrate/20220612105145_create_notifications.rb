class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :sender_id, null: false
      t.integer :recipient_id, null: false
      t.integer :post_id
      t.integer :comment_id
      t.integer :room_id
      t.integer :message_id
      t.string :action, null: false
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
  end
end
