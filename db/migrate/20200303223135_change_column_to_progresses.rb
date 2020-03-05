class ChangeColumnToProgresses < ActiveRecord::Migration[5.2]
  def up
    remove_column :progresses, :status
    add_column :progresses, :title, :string, null: false, default: ""
  end
  def down
    add_column :progresses, :status, :integer, null: false, default: 0
    remove_column :progresses, :title
  end
end
