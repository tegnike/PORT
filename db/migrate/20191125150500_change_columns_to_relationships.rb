class ChangeColumnsToRelationships < ActiveRecord::Migration[5.2]
  def change
    change_column :relationships, :follower_id, :integer, null: false, default: 0
    change_column :relationships, :followed_id, :integer, null: false, default: 0
  end
end
