class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :progress, foreign_key: true
      t.text :comment
      t.float :evaluation

      t.timestamps
    end
    add_index :comments, [:user_id, :progress_id, :created_at]
  end
end
