class CreatePortfolios < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolios do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :content
      t.string :image
      t.string :web_url
      t.string :git_url

      t.timestamps
    end
    add_index :portfolios, [:user_id, :created_at]
  end
end
