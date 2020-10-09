class AddDeletedAtToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :deleted_at, :timestamp, precision: 6
    add_index :comments, :deleted_at
  end
end
