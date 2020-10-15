class AddDeletedAtToUserCapabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :user_capabilities, :deleted_at, :timestamp, precision: 6
    add_index :user_capabilities, :deleted_at
  end
end
