class ChangeColumnNameReport < ActiveRecord::Migration[6.1]
  def change
    rename_column :reports, :object_id, :subject_id
    add_column :reports, :post_id, :integer
  end
end
