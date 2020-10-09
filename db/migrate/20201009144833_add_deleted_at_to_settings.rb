class AddDeletedAtToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :deleted_at, :timestamp, precision: 6
    add_column :setting_values, :deleted_at, :timestamp, precision: 6
    add_index :settings, :deleted_at
    add_index :setting_values, :deleted_at
  end
end
