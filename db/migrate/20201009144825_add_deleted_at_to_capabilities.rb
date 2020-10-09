class AddDeletedAtToCapabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :capability_categories, :deleted_at, :timestamp, precision: 6
    add_column :capabilities, :deleted_at, :timestamp, precision: 6
    add_index :capability_categories, :deleted_at
    add_index :capabilities, :deleted_at
  end
end
