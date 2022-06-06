class AddBooleanDefaultValues < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :is_published, :boolean, default: false, null: false
    change_column :posts, :is_deleted, :boolean, default: false, null: false    
  end
end
