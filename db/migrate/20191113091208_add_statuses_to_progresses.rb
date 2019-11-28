class AddStatusesToProgresses < ActiveRecord::Migration[5.2]
  def change
    add_column :progresses, :status, :integer, null: false, default: 0
  end
end
