class AddDeletedAtToUserCapabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :user_capabilities, :deleted_at, :timestamp
    add_index :user_capabilities, :deleted_at
  end
end
