class CreateProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :progresses do |t|
      t.references :portfolio, foreign_key: true
      t.text :content

      t.timestamps
    end
    add_index :progresses, [:portfolio_id, :created_at]
  end
end
