class AddEngineerToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :engineer, :boolean, default: true
  end
  def down
    remove_column :users, :engineer
  end
end
