class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :portfolio, foreign_key: true

      t.timestamps
    end
    add_index :favorites, [:user_id, :portfolio_id], unique: true
  end
end
