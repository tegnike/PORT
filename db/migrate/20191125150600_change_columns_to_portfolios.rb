class ChangeColumnsToPortfolios < ActiveRecord::Migration[5.2]
  def change
    change_column :portfolios, :title, :string, null: false
    change_column :portfolios, :web_url, :string, null: false
    change_column :portfolios, :git_url, :string, null: false
  end
end
