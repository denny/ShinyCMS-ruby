class AddDeletedAtToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deleted_at, :timestamp
    add_index :users, :deleted_at
  end
end
