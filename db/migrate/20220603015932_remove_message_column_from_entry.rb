class RemoveMessageColumnFromEntry < ActiveRecord::Migration[6.1]
  def change
    remove_column :entries, :message
  end
end
