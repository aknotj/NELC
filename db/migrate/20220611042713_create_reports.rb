class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :model, null: false
      t.integer :object_id, null: false
      t.integer :category, null: false
      t.text :detail
      t.text :note
      t.boolean :is_closed, default: false, null: false

      t.timestamps
    end
  end
end
